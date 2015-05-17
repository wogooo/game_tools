package utils
{
	import com.YFFramework.core.ui.movie.data.TypeAction;

	/**
	 *  @author yefeng
	 *   @time:2012-3-21下午07:50:23
	 */
	public class ActionUtil
	{
		public function ActionUtil()
		{
		}
		
		
		public static  function GetActionName(action:int):String
		{
			switch(action)
			{
				case TypeAction.Stand:
					return "待机";
					break;
				case TypeAction.Walk:
					return "行走";
					break;
				case TypeAction.Attack:
					return "攻击";
					break;
				case TypeAction.Injure:
					return "受击";				
					break;
				case TypeAction.Dead:
					return "死亡";
					break;
				case TypeAction.AtkStand:
					return "战斗待机";
					break;
				case TypeAction.SpecialAtk_1:
					return "特殊攻击1";
					break;
				case TypeAction.SpecialAtk_2:
					return "特殊攻击2";
					break;
				case TypeAction.SpecialAtk_3:
					return "特殊攻击3";
					break;
				case TypeAction.SpecialAtk_4:
					return "特殊攻击4";
					break;
//				case TypeAction.MountStand:
//					return "坐骑上待机";
//					break;
//				case TypeAction.MountWalk:
//					return "坐骑上行走";
//					break;
//				case TypeAction.MountAttack:
//					return "坐骑上攻击";
//					break;
//				case TypeAction.MountInjure:
//					return "坐骑上受击";
//					break;
//				case TypeAction.MountDead:
//					return "坐骑上死亡";
//					break;
//				case TypeAction.Special_Attack_1:
//					return "特殊攻击1";
//					break;
//				case TypeAction.Special_Attack_2:
//					return "特殊攻击2";
//					break;
//				case TypeAction.Special_Attack_3:
//					return "特殊攻击3";
					break;

				
			}
			return null;
		}
		public static function getDirectionName(direction:int):String
		{
			switch(direction)
			{
				case 1:
					return "上";
					break;
				case 2:
					return "右上";
					break;
				case 3:
					return "右";
					break;
				case 4:
					return "右下";				
					break;
				case 5:
					return "下";
					break;
			}
			return null;
		}
	}
}