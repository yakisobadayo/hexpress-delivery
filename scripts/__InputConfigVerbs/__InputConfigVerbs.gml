function __InputConfigVerbs()
{
    enum INPUT_VERB
    {
        //Gameplay
        BOOST,
        DROP,
        START,
        BACK,

        //Main menu
        UP,
        DOWN,
        ACCEPT,
    }

    //Arguments are: verb, export name, keyboard + mouse binding(s), gamepad binding(s)
    InputDefineVerb(INPUT_VERB.BOOST,  "boost",  [vk_space, mb_left],      [gp_face1, gp_shoulderrb]);
    InputDefineVerb(INPUT_VERB.DROP,   "drop",   [vk_down,  mb_right],     [gp_face2, gp_face3, gp_shoulderr]);
    InputDefineVerb(INPUT_VERB.START,  "start",   vk_space,                [gp_face1, gp_start]);
    InputDefineVerb(INPUT_VERB.BACK,   "back",    vk_escape,                gp_select);

    InputDefineVerb(INPUT_VERB.UP,     "up",      vk_up,                   [-gp_axislv, gp_padu]);
    InputDefineVerb(INPUT_VERB.DOWN,   "down",    vk_down,                 [ gp_axislv, gp_padd]);
    InputDefineVerb(INPUT_VERB.ACCEPT, "accept", [vk_enter, vk_space],      gp_face1);
}
