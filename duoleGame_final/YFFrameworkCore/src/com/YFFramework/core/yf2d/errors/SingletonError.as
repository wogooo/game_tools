package com.YFFramework.core.yf2d.errors
{
	/**
	 * author :夜枫
	 * 时间 ：2011-11-12 下午10:31:10
	 */
	/**  单例错误事件
	 */	
	public final class SingletonError extends Error
	{
		public function SingletonError(id:*=0)
		{
			super("此对象为单例，请使用Instance属性", id);
		}
	}
}