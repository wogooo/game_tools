package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.ParticleBasicVo;
	
	import flash.utils.Dictionary;

	/**粒子数据
	 */
	public class ParticleBasicManager
	{
		private static var _instance:ParticleBasicManager;
		private var _dict:Dictionary;
		public function ParticleBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():ParticleBasicManager
		{
			if(_instance==null)_instance=new ParticleBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var particleBasicVo:ParticleBasicVo;
			var arr:Array;
			for (var id:String in jsonData)
			{
				particleBasicVo=new ParticleBasicVo();
				particleBasicVo.layer=jsonData[id].layer;
				particleBasicVo.id=jsonData[id].id;
				particleBasicVo.interval=jsonData[id].interval;
				particleBasicVo.particle_id=jsonData[id].particle_id;
				particleBasicVo.model_id=jsonData[id].model_id;
				particleBasicVo.rotate_type=jsonData[id].rotate_type;
				particleBasicVo.type=jsonData[id].type;
				particleBasicVo.offset=jsonData[id].offset;
				arr=_dict[particleBasicVo.particle_id];
				if(!arr)
				{
					arr=[];
					_dict[particleBasicVo.particle_id]=arr;
				}
				arr=_dict[particleBasicVo.particle_id];
				arr.push(particleBasicVo);
			}
		}
		/**返回的是保存 particleBasicVo的 数组
		 * @param particle_id
		 */
		public function getParticleBasicVo(particle_id:int):Array
		{
			return _dict[particle_id];
		}
	}
}