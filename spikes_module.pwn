/*
    * Module: Spikes
    * Author: 21th years
    *
    * Charge Role Play (c) Charge-rp.ru 2022
*/

#if defined Spikes
    #undef Spikes
#endif
#define Spikes. _spikes

#if defined this
    #undef this
#endif
#define this. _spikes

#if defined COLOR_LIGHT_GRAY
    #undef COLOR_LIGHT_GRAY
#endif
#define COLOR_LIGHT_GRAY    0xc2c2c2ff

#if defined COLOR_WHITE 
    #undef COLOR_WHITE
#endif
#define COLOR_WHITE         0xffffffff

stock Spikes.base_materials = 15_000,
    Spikes.ship_area[MAX_PLAYERS],
    Spikes.put_ships_player[MAX_PLAYERS],
    Spikes.ship_timer[MAX_PLAYERS],
    Spikes.spike_objects[MAX_PLAYERS];

const this.OBJECT_ID = 2892,
    this.TIMER_MILLSEC = 180_000,
    Float:this.RADIUS_SPHERE = 7.0,
    Float:this.Z_DOWN = 0.3,
    this.SUBTRACT_MATERIALS = 300,
    this.MAX_SPIKES = 2,
    this.null = 0,
    this.MAX_COMMAND_LEN = 32,
    this.INVALID_INTERIOR_ID = -1,
    this.INVALID_WORLD_ID = -1,
    this.INVALID_PLAYER_ID = -1,
    this.TIRES_SPIKES = 15;


stock Spikes.Init()
{
    Callback.Add(@OnPlayerCommandText, #this.OnPlayerCommandText);
    Callback.Add(@OnEnterDynamicArea, #this.OnEnterDynamicArea);
    Callback.Add(@OnPlayerDisconnect, #this.OnPlayerDisconnect);

    return true;
}

FUNCTION Spikes.OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[this.MAX_COMMAND_LEN];
    cmdparam(cmd, cmdtext);
 
    if (CMDCompare(cmd, "/spikes", true) )
    {

        new
            Float:x,
            Float:y,
            Float:z,
            Float:angle_int;

        GetPlayerPos(playerid, x,y,z);
        GetPlayerFacingAngle(playerid, angle_int);


        if (GetPlayerInterior(playerid) != this.null) 
            return SendClientMessage(playerid, COLOR_LIGHT_GRAY, " Можно использоваться только на улице.");

        if (IsPlayerInAnyVehicle(playerid)) 
            return SendClientMessage(playerid, COLOR_LIGHT_GRAY, " Вы должны находиться вне автомобиля.");

        if (this.base_materials < this.SUBTRACT_MATERIALS) 
            return SendClientMessage(playerid, COLOR_LIGHT_GRAY, " На базе меньше 300 материалов");

        if (this.put_ships_player[playerid] >= this.MAX_SPIKES) 
            return SendClientMessage(playerid, COLOR_LIGHT_GRAY, " Подождите, пока прошлые шипы придут в негодность.");
        

        this.spike_objects[playerid] = CreateDynamicObject(this.OBJECT_ID,x,y,z-this.Z_DOWN,this.null,
        this.null,
        angle_int);

        this.ship_area[playerid] = CreateDynamicSphere(x, y, z, this.RADIUS_SPHERE,
        this.INVALID_WORLD_ID, this.INVALID_INTERIOR_ID, this.INVALID_PLAYER_ID);

        this.ship_timer[playerid] = SetTimerEx(#this.ClearShips, this.TIMER_MILLSEC,
        false, "d", playerid);


        this.put_ships_player[playerid]++;
        this.base_materials -= this.SUBTRACT_MATERIALS;

        return SendClientMessage(playerid, COLOR_WHITE, " Вы установили шипы. Время действия: 3 минуты");;
    }

    return true;
}

FUNCTION Spikes.ClearShips(playerid)
{
    this.put_ships_player[playerid]--;

    if (this.put_ships_player[playerid] == this.null)
    {
        DestroyDynamicObject(this.spike_objects[playerid]);
        DestroyDynamicArea(this.ship_area[playerid]);

        this.spike_objects[playerid] = this.null;

        return SendClientMessage(playerid, COLOR_LIGHT_GRAY, " Ваши шипы пришли в не пригодность!");
    }
    return true;
}

FUNCTION Spikes.OnEnterDynamicArea(playerid, areaid)
{
    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        for (new i, k; i < k; k = GetPlayerPoolSize(), i++ )
        {
            if (areaid == this.ship_area[i])
            {
                new panels, doors, lights, tires;
                GetVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, tires);
                UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, this.TIRES_SPIKES);
                break;
            }
        }
    }
    return true;
}

FUNCTION Spikes.OnPlayerDisconnect(playerid, reason)
{
    if (this.spike_objects[playerid] != this.null)
    {
        DestroyDynamicObject(this.spike_objects[playerid]);
        DestroyDynamicArea(this.ship_area[playerid]);
    }
    return true;
}

#undef this