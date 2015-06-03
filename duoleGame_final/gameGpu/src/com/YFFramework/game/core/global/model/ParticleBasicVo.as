package com.YFFramework.game.core.global.model
{
	public class ParticleBasicVo
	{

		public var layer:int;
		public var id:int;
		public var interval:int;
		public var particle_id:int;
		public var model_id:int;
		
		/**旋转类型值在TypeSkill.ParticleLayer_Rotate_
		 */
		public var rotate_type:int;
		
		
		/**技能类型  值 在 TypeSkill.ParticleType_Follow
		 */
		public var type:int;
		
		/**技能偏移
		 **/
		public var offset:Array;

		public function ParticleBasicVo()
		{
		}
	}
}