#define FARMLAND_NO_PLANT "missing"
#define FARMLAND_PLANT_GROWING "growing"
#define FARMLAND_CYCLE_DELAY 20 SECONDS

/datum/component/farmland
	var/water_level = 0
	var/max_water = 100

	var/obj/item/seeds/myseed
	var/age
	var/plant_status = FARMLAND_NO_PLANT
	var/lastproduce = 0
	var/lastcycle = 0
	var/cycledelay = FARMLAND_CYCLE_DELAY
	var/harvestablecycles = 15

	var/obj/item/stack/fertilizer/current_fertilizer
	var/water_modifier = 0
	
	var/mutable_appearance/plant_overlay

/datum/component/farmland/Initialize()
	if(!isturf(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(examine))
	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(action))

	START_PROCESSING(SSobj, src)

/datum/component/farmland/Destroy(force)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/datum/component/farmland/proc/examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += myseed ? "It has a <b>[myseed.plantname]</b> planted." : "It looks ready to be used."
	if (water_level == 0)
		examine_list += "It looks a bit dry."

/datum/component/farmland/proc/action(datum/source, obj/item/I, mob/living/user)
	SIGNAL_HANDLER

	var/turf/open/ourparent = parent
	if(.)
		return TRUE

	if(istype(I, /obj/item/stack/fertilizer))
		var/obj/item/stack/fertilizer/our_fertilizer = I
		if ((plant_status != FARMLAND_NO_PLANT) || current_fertilizer)
			our_fertilizer.balloon_alert(user, "occupied")
			return
		else
			our_fertilizer.apply_effect(src)
			our_fertilizer.balloon_alert(user, "added [our_fertilizer]")
			our_fertilizer.use(1)
			current_fertilizer = new our_fertilizer.type(parent, 1)
			current_fertilizer.AddElement(/datum/element/undertile, invisibility_level = INVISIBILITY_ABSTRACT, use_anchor = TRUE)
			ourparent.levelupdate()
			return

	if (istype(I, /obj/item/seeds))
		var/obj/item/seeds/our_seeds = I
		if (plant_status == FARMLAND_NO_PLANT)
			set_seed(our_seeds)
			age = 1
			harvestablecycles = (our_seeds.lifespan + our_seeds.endurance)/5
			lastcycle = world.time
			return
		else
			our_seeds.balloon_alert(user, "plant present")
			return

	return .

/datum/component/farmland/proc/set_seed(obj/item/seeds/new_seed)
	var/turf/open/ourparent = parent
	myseed = new_seed
	plant_status = FARMLAND_PLANT_GROWING
	if(myseed && myseed.loc != parent)
		myseed.forceMove(parent)
		myseed.AddElement(/datum/element/undertile, invisibility_level = INVISIBILITY_ABSTRACT, use_anchor = TRUE)
		ourparent.levelupdate()
	update_plant_overlay()

/datum/component/farmland/process(seconds_per_tick)

	if(world.time > (lastcycle + cycledelay))
		lastcycle = world.time

		if(myseed)
			water_level = clamp(water_level - rand(1,4) + water_modifier, 0, max_water)
			// Advance age
			if (water_level > 0)
				age++
				if(age >= harvestablecycles)
					new myseed.product(parent)
					plant_status = FARMLAND_NO_PLANT
					QDEL_NULL(myseed)
					if (prob(2) && current_fertilizer)
						remove_fertilizer()
				update_plant_overlay()

/datum/component/farmland/proc/remove_fertilizer()
	if (!current_fertilizer)
		return

	current_fertilizer.remove_effect()
	QDEL_NULL(current_fertilizer)

/datum/component/farmland/proc/update_plant_overlay()
	var/turf/open/our_parent = parent
	our_parent.cut_overlay(plant_overlay)
	if (!myseed)
		return
	plant_overlay = mutable_appearance(myseed.growing_icon, layer = OBJ_LAYER + 0.01)
	var/t_growthstate = clamp(round((age / myseed.maturation) * myseed.growthstages), 1, myseed.growthstages)
	plant_overlay.icon_state = "[myseed.icon_grow][t_growthstate]"
	plant_overlay.pixel_y = myseed.plant_icon_offset
	our_parent.overlays += plant_overlay
