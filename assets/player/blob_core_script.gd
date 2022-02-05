extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var directionVector: Vector3;
var deltaTimePassed: float;
var rng = RandomNumberGenerator.new();
var cumulatedVector = Vector3(0.0, 0.0, 0.0);
var speed = 0.0;

export var changeTime = 0.2;
export var maxBound : Vector3;
export var minBound : Vector3;
export var minSpeed : float;
export var maxSpeed : float;

# Called when the node enters the scene tree for the first time.
func _ready():
    directionVector = Vector3(rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0)).normalized();
    speed = rng.randf_range(minSpeed, maxSpeed);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if (deltaTimePassed > changeTime):
        speed = rng.randf_range(minSpeed, maxSpeed);
        var newDirectionVector = Vector3(rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0)).normalized();
        if (newDirectionVector.dot(directionVector) > 0):
            directionVector = -newDirectionVector;
        else:
            directionVector = newDirectionVector;

        deltaTimePassed = 0.0;
    else :
        deltaTimePassed += delta;

    cumulatedVector += speed * directionVector * delta;
    if (cumulatedVector.x < maxBound.x && cumulatedVector.x > minBound.x &&
        cumulatedVector.y < maxBound.y && cumulatedVector.y > minBound.y &&
        cumulatedVector.z < maxBound.z && cumulatedVector.z > minBound.z):
        translation += speed * directionVector * delta;
    else:
        cumulatedVector -= speed * directionVector * delta;
        directionVector = -directionVector;
        translation += speed * directionVector * delta;
        cumulatedVector += speed * directionVector * delta;
