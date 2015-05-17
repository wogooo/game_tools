package events
{
	/**
	 *  @author yefeng
	 *   @time:2012-4-5下午05:38:50
	 */
	import flash.events.Event;
	
	public class ParamEvent extends Event
	{
	
		private static const Path:String="events.";
		/**再一次播放 
		 */
		public static const PlayAgain:String=Path+"PlayAgain";
		
		
		public static const HideFrame:String=Path+"HideFrame";
		public static const ShowFrame:String=Path+"ShowFrame";
		
		/**改变帧频
		 */		
	//	public static const ChangeFrameRate:String=Path+"ChangeFrameRate";
		
		/**血条控制     TypeBlood 
		 */
		public static  const Blood:String=Path+"Blood";
		
		/**  血条显示面板更新
		 */
		public static const BloodPaneUpdate:String=Path+"BloodPaneShow";
		
		
		/**查看帧的信息 也就是查看BitmapDataEx的信息
		 */
		public static  const ViewFrameInfo:String=Path+"ViewFrameInfo";
		
		/**删除帧
		 */
		public static const DeleteFrame:String=Path+"DeleteFrame";
		
		/**刷新重新播放
		 */
		public static const FlushPlay:String=Path+"FlushPlay";
		/**角色播放触发
		 */
		public static const RolePlay:String=Path+"RolePlay";
		
		/**角色开始播放
		 */
		public static const RoleBeginPlay:String=Path+"RoleBeginPlay";
		
		/**导出文件
		 */		
		public static const ExportFile:String=Path+"ExportFile";
		
		/**显示角色的边框以及 原点等信息
		 */		
		public  static const ShowRoleInfo:String=Path+"ShowRoleInfo";
		
		/**显示参照物一的边框以及 原点等信息
		 */
		public  static const ShowRefRoleInfo:String=Path+"ShowRefRoleInfo";
		/**显示参照物二的边框以及 原点等信息
		 */
		public  static const ShowRefRoleInfo2:String=Path+"ShowRefRoleInfo2";
		
		/**角色创建后触发
		 */
		public static const RoleCreate:String=Path+"RoleCreate";
		/**参照物角色1创建后触发
		 */		
		public static const RefRoleCreate:String=Path+"RefRoleCreate";
		/**参照物角色2创建后触发
		 */
		public static const RefRole2Create:String=Path+"RefRole2Create";
		
		/**改变角色深度
		 */
		public static const ChangeRoleDeep:String=Path+"ChangeRoleDeep";
		/**混合模式发生改变
		 */		
		public static const BlenderModeChange:String=Path+"BlenderModeChange";
		
		public var data:Object;
		
		public function ParamEvent(type:String,data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data=data;
		}
	}
}