// tidy up the parcel’s particles
if (ps_id != noone) {
    part_system_destroy(ps_id);
    ps_id = noone;      // safety
}