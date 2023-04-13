/*
    * Module: Jobs (Професии)
    * Author: 21th years
    *
    * For Arizona RP (c) arizona-rp.com 2023
*/

#if defined _sms_module_
    #undef _sms_module_
#endif

#if defined _sms_module_
    #endinput
#endif
#define _sms_module_

#if defined message
    #undef message
#endif
#define message. _sms

#if defined this
    #undef this
#endif
#define this. _sms

#if defined COLOR_LIGHT_GRAY
    #undef COLOR_LIGHT_GRAY
#endif
#define COLOR_LIGHT_GRAY    0xc2c2c2ff

#if defined COLOR_WHITE
    #undef COLOR_WHITE
#endif
#define COLOR_WHITE         0xffffffff



#define random_ex(%0,%1,%2) %0+(random((%1-%0)/%2+1)*%2)

const this.NUMBER_MIN = 100_000_000_0,
    this.NUMBER_MAX = 999_999_999_99,
    this.PHONE_COUNT_MONEY = 5,
    this.MAX_SIZEOF_STRING = (120+12+(-4)),
    this.NUMBER_INTERVAL = 5;

enum _phone_base {
    bool:aPhone = false,
    aSimNumber[12]
};
new eInfo[MAX_PLAYERS][_phone_base];

public OnPlayerCommandText(playerid, cmdtext[])
{
    
    if(!strcmp(cmdtext, "/buyphone"))
    {
        if( GetPlayerMoney(playerid) < this.PHONE_COUNT_MONEY ) return
            SendClientMessage(playerid, COLOR_LIGHT_GRAY, " У вас недостаточно средств. Необходимо $5.");
        if( !IsPlayerHavePhone(playerid)) return
            SendClientMessage(playerid, COLOR_LIGHT_GRAY, " У вас уже имеется мобильный телефон.");
        
        eInfo[playerid][aPhone] = true;
        eInfo[playerid][aSimNumber] = random_ex(this.NUMBER_MIN, this.NUMBER_MAX, this.NUMBER_INTERVAL);
        
        new replaced_string[this.MAX_SIZEOF_STRING] = "Вы приобрели мобильное устройство за $%d. Мобильный номер: %d";
        format(replaced_string, sizeof replaced_string, replaced_string, this.PHONE_COUNT_MONEY, eInfo[playerid][aSimNumber]);

        return
            SendClientMessage(playerid, COLOR_LIGHT_GRAY, replaced_string);

    }

    #if defined jobs_OnPlayerCommandText
        return jobs_OnPlayerCommandText(playerid, cmdtext[]);
    #else
        return true;
    #endif
}
#if defined _ALS_OnPlayerCommandText
    #undef OnPlayerCommandText
#else
    #define _ALS_OnPlayerCommandText
#endif

#define OnPlayerCommandText jobs_OnPlayerCommandText
#if defined jobs_OnPlayerCommandText
    forward jobs_OnPlayerCommandText(playerid, cmdtext[]);
#endif

public OnPlayerDisconnect(playerid)
{
    
    #if defined jobs_OnPlayerDisconnect
        return jobs_OnPlayerDisconnect(playerid);
    #else
        return true;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect jobs_OnPlayerDisconnect
#if defined jobs_OnPlayerDisconnect
    forward jobs_OnPlayerDisconnect(playerid);
#endif

stock IsPlayerHavePhone(playerid) 
{
    if(eInfo[playerid][aPhone] == true) 
        return true;
    else
        return false;
}

#undef this