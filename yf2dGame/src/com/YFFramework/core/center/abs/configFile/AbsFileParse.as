package com.YFFramework.core.center.abs.configFile
{

	/**
	 * author :夜枫 * 时间 ：2011-9-25 下午05:14:00
	 * 对加载的文本文件 比如xml  csv进行格式化处理 也就是 进行解析 
	 * 该类负责解析所在加载的文件 在该类中可以使用AbsConfigFile.data的属性了 因为此时data属性已经有效了   其他ui类中可以直接使用 AbsFileParse类实例，用来创建界面
	 * 
	 *   该类的子类 实例就可以得到具体的数据了
	 */
	public class AbsFileParse
	{
		public function AbsFileParse()
		{
			initData();
			parse();
		}
		protected function initData():void
		{
			
		}
		
		protected function parse():void
		{
			
		}
		
	}
}