/obj/item/hoe
	name = "hoe"
	desc = "A large tool for tiling farmland."
	icon = 'icons/obj/mining.dmi'
	icon_state = "shovel"
	inhand_icon_state = "shovel"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	force = 8
	throwforce = 4
	tool_behaviour = TOOL_HOE
	toolspeed = 1
	usesound = 'sound/effects/shovel_dig.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5)
	attack_verb_continuous = list("bashes", "bludgeons", "thrashes", "whacks")
	attack_verb_simple = list("bash", "bludgeon", "thrash", "whack")
	sharpness = SHARP_EDGED

/obj/item/hoe/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 15 SECONDS, \
	effectiveness = 40, \
	)
