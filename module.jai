Transform :: struct {
	q : Quaternion;
	p : Vector3;
}

Scene :: *void;
Material :: *void;
Actor :: *void;
Triangle_Mesh :: *void;
Convex_Mesh :: *void;
Controller :: *void;

Allocator :: struct {
	allocate_16_byte_aligned: #type (allocator : *Allocator, size : u64, filename : *u8, line : s32) -> *void #c_call;
	deallocate: #type (allocator : *Allocator, ptr : *void) #c_call;
	user_data: *void;
}

Buffer :: struct {
	data : *void;
	size : u64;
}

Mesh_Description :: struct {
	vertices : *Vector3;
	num_vertices : u32;
	vertex_stride : u32;
	indices : *u32;
	num_triangles : u32;
	triangle_stride : u32;
}

Contact :: struct {
	actor0 : Actor;
	actor1 : Actor;
	pos : Vector3;
	normal : Vector3;
	impulse : Vector3;
}

Trigger_State :: enum s32 {
	eNOTIFY_TOUCH_FOUND;
	eNOTIFY_TOUCH_LOST;
}

Trigger :: struct {
	trigger : Actor;
	other_actor : Actor;
	state : Trigger_State;
}

Query_Hit :: struct {
	valid : bool;
	pos : Vector3;
	normal : Vector3;
}


Controller_Settings :: struct {
	slope_limit_deg : float;
	height : float;
	radius : float;
	up : Vector3;
	shape_layer_index : s32;
	mask_index : s32;
	material : Material;
}

	init :: (allocator : Allocator, initialize_cooking : bool, initialize_pvd : bool) #foreign physx "px_init";

	destroy :: () #foreign physx "px_destroy";


	scene_create :: () -> Scene #foreign physx "px_scene_create";

	scene_release :: (scene : Scene) #foreign physx "px_scene_release";

	scene_simulate :: (scene : Scene, dt : float, scratch_memory_16_byte_aligned : *void = null, scratch_size : u64 = 0) #foreign physx "px_scene_simulate";

	scene_set_gravity :: (scene : Scene, gravity : Vector3) #foreign physx "px_scene_set_gravity";

	scene_add_actor :: (scene : Scene, actor : Actor) #foreign physx "px_scene_add_actor";

	scene_remove_actor :: (scene : Scene, actor : Actor) #foreign physx "px_scene_remove_actor";

	_scene_get_active_actors :: (scene : Scene, num_active : *u32) -> *Actor #foreign physx "px_scene_get_active_actors";

	_scene_get_contacts :: (scene : Scene, num_contacts : *u32) -> *Contact #foreign physx "px_scene_get_contacts";

	_scene_get_triggers :: (scene : Scene, num_triggers : *u32) -> *Trigger #foreign physx "px_scene_get_triggers";


	scene_set_collision_mask :: (scene : Scene, mask_index : s32, layer_mask : u64) #foreign physx "px_scene_set_collision_mask";

	scene_raycast :: (scene : Scene, origin : Vector3, direction : Vector3, distance : float, mask_index : s32) -> Query_Hit #foreign physx "px_scene_raycast";


	material_create :: (static_friction : float, dynamic_friction : float, restitution : float) -> Material #foreign physx "px_material_create";

	material_release ::(material : Material) #foreign physx "px_material_release";


	actor_create :: () -> Actor #foreign physx "px_actor_create";

	actor_release :: (actor : Actor) #foreign physx "px_actor_release";

	actor_get_user_data :: (actor : Actor) -> *void #foreign physx "px_actor_get_user_data";

	actor_set_user_data :: (actor : Actor, user_data : *void) #foreign physx "px_actor_set_user_data";

	actor_set_kinematic :: (actor : Actor, kinematic : bool) #foreign physx "px_actor_set_kinematic";

	actor_get_transform :: (actor : Actor) -> Transform #foreign physx "px_actor_get_transform";

	actor_set_transform :: (actor : Actor, transform : Transform, teleport := false) #foreign physx "px_actor_set_transform";

	actor_get_velocity :: (actor : Actor) -> Vector3 #foreign physx "px_actor_get_velocity";

	actor_set_velocity :: (actor : Actor, linear_velocity : Vector3) #foreign physx "px_actor_set_velocity";

	actor_add_shape_box :: (actor : Actor, half_extents : Vector3, material : Material, shape_layer_index : s32, mask_index : s32, trigger : bool) #foreign physx "px_actor_add_shape_box";

	actor_add_shape_sphere :: (actor : Actor, radius : float, material : Material, shape_layer_index : s32, mask_index : s32, trigger : bool) #foreign physx "px_actor_add_shape_sphere";

	actor_add_shape_triangle_mesh :: (actor : Actor, triangle_mesh : Triangle_Mesh, material : Material, shape_layer_index : s32, mask_index : s32) #foreign physx "px_actor_add_shape_triangle_mesh";

	actor_add_shape_convex_mesh :: (actor : Actor, convex_mesh : Convex_Mesh, material : Material, shape_layer_index : s32, mask_index : s32) #foreign physx "px_actor_add_shape_convex_mesh";


	cook_triangle_mesh :: (mesh_description : Mesh_Description) -> Buffer #foreign physx "px_cook_triangle_mesh";

	cook_convex_mesh :: (mesh_description : Mesh_Description) -> Buffer #foreign physx "px_cook_convex_mesh";

	buffer_free :: (buffer : Buffer) #foreign physx "px_buffer_free";


	triangle_mesh_create :: (buffer : Buffer) -> Triangle_Mesh #foreign physx "px_triangle_mesh_create";

	triangle_mesh_release :: (triangle_mesh : Triangle_Mesh) #foreign physx "px_triangle_mesh_release";

	convex_mesh_create :: (buffer : Buffer) -> Convex_Mesh #foreign physx "px_convex_mesh_create";

	convex_mesh_release :: (convex_mesh : Convex_Mesh) #foreign physx "px_convex_mesh_release";


	controller_create :: (scene : Scene, controller_settings : Controller_Settings) -> Controller #foreign physx "px_controller_create";

	controller_release :: (controller : Controller) #foreign physx "px_controller_release";

	controller_get_position :: (controller : Controller) -> Vector3 #foreign physx "px_controller_get_position";

	controller_set_position :: (controller : Controller, position : Vector3) #foreign physx "px_controller_set_position";

	controller_move :: (controller : Controller, displacement : Vector3, dt : float, mask_index : s32) -> u8 #foreign physx "px_controller_move";

#scope_file
#import "Basic";
#import "Math";

physx :: #library,no_dll "lib/physx_lib";