class_name FlyPath
extends Path2D

@export var segment_length: float = 50.0
@export var curve_strength: float = 3.0
@export var max_points: int = 8
@export var lookahead_distance: float = 300.0

@export_group("Dashed Line")
@export var dash_length: float = 2.0
@export var gap_length: float = 10.0
@export var line_width: float = 1.0
@export var line_color: Color = Color.WHITE
@export var draw_distance: float = 150.0 ## How far ahead of the fly to draw the path (0 = infinite)

var last_point: Vector2 = Vector2.ZERO
var last_out_tangent: Vector2 = Vector2.ZERO
var direction_angle: float = 0.0
var noise: FastNoiseLite

func _ready() -> void:
	# Initialize noise for smooth curve generation
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = .24 # Higher frequency for more swings
	
	# Create initial curve
	curve = Curve2D.new()
	last_point = Vector2.ZERO
	last_out_tangent = Vector2.RIGHT * curve_strength
	
	# Generate initial path segments
	for i in range(max_points):
		_add_next_point()

func _process(_delta: float) -> void:
	# Check if we need to extend the path
	var followers = get_children().filter(func(child): return child is PathFollow2D)
	if followers.size() > 0:
		var follower = followers[0] as PathFollow2D
		var remaining_distance = curve.get_baked_length() - follower.progress
		
		# If the follower is getting close to the end, add more points
		if remaining_distance < lookahead_distance:
			_add_next_point()
	
	# Remove old points if we have too many
	if curve.point_count > max_points:
		# Get the baked length of the segment being removed
		var old_length = curve.get_baked_length()
		curve.remove_point(0)
		var new_length = curve.get_baked_length()
		var segment_removed = old_length - new_length
		
		# Adjust follower progress to compensate for removed point
		for child in get_children():
			if child is PathFollow2D:
				child.progress = max(0, child.progress - segment_removed)
	
	queue_redraw()

func set_direction_from_fly(fly_progress: float) -> void:
	"""Update the path direction based on the fly's current movement direction"""
	if curve.point_count < 2:
		return
	
	# Get the tangent at the fly's current position
	var tangent = curve.sample_baked_with_rotation(fly_progress).x
	if tangent != Vector2.ZERO:
		direction_angle = tangent.angle()

func _add_next_point() -> void:
	var point_count = curve.point_count
	
	# Use noise to create smooth, flowing direction changes
	var noise_value = noise.get_noise_1d(point_count * 0.8)
	direction_angle += noise_value * 1.2 # Much stronger angle changes for swingier curves
	
	# Calculate next point
	var direction = Vector2.RIGHT.rotated(direction_angle)
	var next_point = last_point + direction * segment_length
	
	# Calculate tangent handles for smooth Bezier curves
	# In tangent should flow from the previous direction
	var in_tangent = - last_out_tangent
	
	# Out tangent points in the new direction with some variation
	var tangent_noise = noise.get_noise_1d(point_count * 0.8 + 50)
	var tangent_angle = direction_angle + tangent_noise * 2.8 # More tangent variation
	var out_tangent = Vector2.RIGHT.rotated(tangent_angle) * curve_strength
	
	# Add the point with its tangent handles
	curve.add_point(next_point, in_tangent, out_tangent)
	
	# Update last values for next iteration
	last_point = next_point
	last_out_tangent = out_tangent

func _draw() -> void:
	if curve == null or curve.point_count < 2:
		return
	
	# Draw dashed line from the fly's current position forward
	var followers = get_children().filter(func(child): return child is PathFollow2D)
	var start_draw_distance = followers[0].progress if followers.size() > 0 else 0.0
	
	# Calculate end draw distance
	var total_length = curve.get_baked_length()
	var end_draw_distance = total_length if draw_distance <= 0 else min(start_draw_distance + draw_distance, total_length)
	
	# Draw dashed line along the curve
	var current_distance: float = start_draw_distance
	var dash_pattern_length = dash_length + gap_length
	
	while current_distance < end_draw_distance:
		var dash_start = current_distance
		var dash_end = min(current_distance + dash_length, end_draw_distance)
		
		# Draw this dash segment
		var start_pos = curve.sample_baked(dash_start)
		var end_pos = curve.sample_baked(dash_end)
		
		# Sample multiple points for smoother dashes on curves
		var steps = max(2, int((dash_end - dash_start) / 5.0))
		var dash_points: PackedVector2Array = []
		
		for i in range(steps + 1):
			var t = dash_start + (dash_end - dash_start) * (float(i) / steps)
			dash_points.append(curve.sample_baked(t))
		
		# Draw the polyline for this dash
		if dash_points.size() >= 2:
			draw_polyline(dash_points, line_color, line_width, true)
		
		current_distance += dash_pattern_length
