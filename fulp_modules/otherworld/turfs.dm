/turf/open/misc/grass/tileable
	name = "farmland"
	desc = "A patch of farmland."
	icon = 'icons/turf/floors.dmi'
	icon_state = "grass"
	base_icon_state = "grass"
	smoothing_flags = null
	underfloor_accessibility = UNDERFLOOR_HIDDEN
	var/tiled

/turf/open/misc/grass/tileable/attackby(obj/item/attack_item, mob/user, params)
	. = ..()
	if(.)
		return TRUE

	if(attack_item.tool_behaviour == TOOL_HOE)
		if(!can_tile(user))
			return TRUE

		if(!isturf(user.loc))
			return

		balloon_alert(user, "tiling...")

		if(attack_item.use_tool(src, user, 2 SECONDS, volume = 50))
			if(!can_tile(user))
				return TRUE
			getTiled()
			return TRUE

/turf/open/misc/grass/tileable/proc/getTiled()
	if(tiled)
		return
	tiled = TRUE
	AddComponent(/datum/component/farmland)
	update_appearance()

/turf/open/misc/grass/tileable/proc/can_tile(mob/user)
	if(!tiled && !broken)
		return TRUE
	if(user)
		balloon_alert(user, "already tiled!")
