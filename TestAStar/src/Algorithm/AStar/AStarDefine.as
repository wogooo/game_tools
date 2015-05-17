package Algorithm.AStar
{
	public class AStarDefine
	{
		public function AStarDefine()
		{
			throw new Error("无法实例化 AStarDefine$ 类。", 2012);
		}
		
		// 移动方向
		public static const MOVE_RIGHT:int 				= 1;	
		public static const MOVE_TOP:int 				= 2;
		public static const MOVE_LEFT:int 				= 4;
		public static const MOVE_BOTTOM:int 			= 8;
		
		// 方向值
		public static var s_dir:Array = [ 1, 2, 4, 8, 1|2, 2|4, 4|8, 8|1 ];
		
												//	0		1		2		3		4		5		6		7		8		9		10		11		12	
		public static var s_colOffset:Array = [ 0xFFFFFF,	1,		0,		1,		-1,	0xFFFFFF,	-1,	0xFFFFFF,	0,		1,	0xFFFFFF,0xFFFFFF,	-1 ];
												//	0		1		2		3		4		5		6		7		8		9		10		11		12	
		public static var s_rowOffset:Array = [ 0xFFFFFF,	0,		-1,		-1,		0,	0xFFFFFF,	-1,	0xFFFFFF,	1,		1,	0xFFFFFF,0xFFFFFF,	1 ];
	}
}