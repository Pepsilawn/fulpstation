/obj/item/stack/fertilizer
	name = "fertilizer"
	desc = "Helps boost a plant's stats."
	icon = 'icons/obj/machines/prison.dmi'
	icon_state = "empty_plate"
	max_amount = 50
	merge_type = /obj/item/stack/fertilizer

	var/growth_speed

/obj/item/stack/fertilizer/proc/apply_effect(var/datum/component/farmland/our_plot)
	return

/obj/item/stack/fertilizer/proc/remove_effect(var/datum/component/farmland/our_plot)
	return

/obj/item/stack/fertilizer/speedgro
	name = "\improper Speed-Gro fertilizer"
	desc = "Apply to empty farmland to boost a plant's growth cycle by <b>25%</b>."
	merge_type = /obj/item/stack/fertilizer/speedgro

/obj/item/stack/fertilizer/speedgro/apply_effect(our_plot)
	var/datum/component/farmland/plot = our_plot
	plot.cycledelay = max((plot.cycledelay * 0.75 SECONDS), 10 SECONDS)

/obj/item/stack/fertilizer/speedgro/remove_effect(our_plot)
	var/datum/component/farmland/plot = our_plot
	plot.cycledelay = max((plot.cycledelay / 0.75 SECONDS), 10 SECONDS)
