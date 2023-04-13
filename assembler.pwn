#include <a_samp>
#define MAX_CUSTOM_CALLBACKS 34
#define MAX_CUSTOM_CALLBACKS_NAME 9
#define SIZE_OF_ADRESS_LEN 11
const MAX_PARAM_LEN = MAX_CUSTOM_CALLBACKS*MAX_CUSTOM_CALLBACKS_NAME


stock Module.OnPlayerConnect(playerid)
{
    new data[MAX_CUSTOM_CALLBACKS_NAME*MAX_CUSTOM_CALLBACKS];
    format(data, sizeof(data), "%s", Callback.data[@OnPlayerConnect]);
    do
    {
        new address[SIZE_OF_ADRESS_LEN];
        cmdparam(address, data, _, ",");


        if (isnull(address) || strval(address) <= 0)
            continue;
       
        Callback.Push(playerid);
        Callback.Call(strval(address));
    }
    //while (strlen(data)); Рекурсия

    return true;
}


stock cmdparam(string[])
{
    new first[MAX_PARAM_LEN] = "-1";
    if(!string[0]) return first;
    new space = strfind(string, " ");
    if(space == -1)
    {
        format(first, MAX_PARAM_LEN, string);
        string[0] = 0;
    }
    else
    {
        strmid(first, string, 0, space, MAX_PARAM_LEN);
        strdel(string, 0, space + 1);
    }
    return first;
}
