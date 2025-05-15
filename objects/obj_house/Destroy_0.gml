if (state == HouseState.PENDING)
{
    state = HouseState.MISSED;
    manager.dropoffs[slot] = HouseState.MISSED;
}