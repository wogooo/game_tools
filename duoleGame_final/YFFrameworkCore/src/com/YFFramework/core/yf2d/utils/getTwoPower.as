package com.YFFramework.core.yf2d.utils
{
    /** 2 ci fang */
    public function getTwoPower(number:int):int
    {
        if (number > 0 && (number & (number - 1)) == 0) // see: http://goo.gl/D9kPj
            return number;
        else
        {
            var result:int = 1;
            while (result < number) result <<= 1;
            return result;
        }
    }
}