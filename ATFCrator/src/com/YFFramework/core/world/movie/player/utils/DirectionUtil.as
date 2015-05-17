package com.YFFramework.core.world.movie.player.utils
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.ui.movie.data.TypeDirection;

	/**
	 * 得到方向
	 * @author yefeng
	 *2012-4-22下午2:12:31
	 */
	public class DirectionUtil
	{
		
		/**分割角度      [-segment,segment]为右方向 以此类推
		 */
		private static const Segment:int=22;
		
		private static const _360__Segment:int=360-Segment;
		private static const _90__Segment:int=90-Segment;
		
		private static const _90_Segent:int=90+Segment;
		private static const  _180__Segment:int=180-Segment;
		private static const _180_Segment:int=180+Segment;
		
		private static const _270__Segement:int=270-Segment;
		
		private static const _270_Segement:int=270+Segment;
		
		public function DirectionUtil()
		{
		}

		
	
		
		public  static function getDirection(startX:Number,startY:Number,endX:Number,endY:Number):int
		{
			var direction:int;
			if(endX!=startX)
			{
				// 15度 最佳  
				var hudu:Number=Math.atan2(endY-startY+0.0000001,endX-startX+0.0000001);
				var jiaodu:Number=hudu*180/Math.PI;
				//  以 15度 为分割线
				if(jiaodu<0)
				{
					jiaodu +=360;
				}
				if(jiaodu<=Segment||jiaodu>=_360__Segment)
				{
					return   TypeDirection.Right;//右 
				}
				else if(jiaodu>=Segment&&jiaodu<=_90__Segment)
				{
					return  TypeDirection.RightDown ;//右下
				}
				else if(jiaodu>=_90__Segment&&jiaodu<=_90_Segent)
				{
					return TypeDirection.Down;//下
				}
				else if(jiaodu>=_90_Segent&&jiaodu<=_180__Segment)
				{
					return  TypeDirection.LeftDown;//左下
				}
				else if(jiaodu>=_180__Segment&&jiaodu<=_180_Segment)
				{
					return TypeDirection.Left;//左
				}
				else if(jiaodu>=_180_Segment&&jiaodu<=_270__Segement)
				{
					return TypeDirection.LeftUp ;//左上
				}
				else if(jiaodu>=_270__Segement&&jiaodu<=_270_Segement)    ///上
				{ 
					return TypeDirection.Up;
				}
				else if(jiaodu>=_270_Segement&&jiaodu<=_360__Segment) //右上
				{
					return TypeDirection.RightUp;
				}
			}
			else 
			{
				if(endY>startY)  return TypeDirection.Down;  ///下
				else return  TypeDirection.Up ;//上
			}
			return -1;			
		}
		
		
		/**根据direction 得到相应的角度
		 */ 
		public static function getDirectionDegree(direction:int):int
		{
			switch(direction)
			{
				case TypeDirection.Up:
					return 270;
				case TypeDirection.RightUp:
					return 315;
				case TypeDirection.Right:
					return 0;
				case TypeDirection.RightDown:
					return 45;
				case TypeDirection.Down:
					return 90;
				case TypeDirection.LeftDown:
					return 135;
				case TypeDirection.Left:
					return 180;
				case TypeDirection.LeftUp:
					return 225;
			}
			return 0;
		}
		
		/**   direction 的上一个方向 并且这个方向是向上的
		 */		
//		public static function getUpDirection(direction:int):int
//		{
//			if(direction<=5)
//				return (direction-1+8)%8;
//			return (direction+1)%8
//		}
//		
//		public static function getDownDirection(direction:int):int
//		{
//			if(direction<=5)
//				return (direction+1)%8;
//			return (direction-1+8)%8
//		}
		
		
		/**  获取角度    根据len（为 1  2 3  获取数组）   该方法也就是宠物站立的角度位置  类似魔域
		 * @param direction
		 * @param len
		 * @return
		 */		
		public static function getDegreeArr(direction:int,len:int):Array
		{
			var arr:Array;
			if(len==1)
			{
				var degree:int=getDirectionDegree(direction);
				arr=[degree];
			}
			else if(len==2) arr= get2LenDegreeArr(direction);
			else if(len==3) arr= get3LenDegreeArr(direction);
			return arr;
		}
		
		/** 获取长度为2 的数组    
		 * direction 是当前角色的方向  
		 * 返回的是数组是 该人物方向下 宠物所应该站立的角度 
		 */ 
		private static function get2LenDegreeArr(direction:int):Array
		{
			var degree:int=DirectionUtil.getDirectionDegree(direction);;
			var arr:Array=[];
			var left:int=degree-30;
			var right:int=degree+30;
			arr.push(left,right);
			return arr;
		}
		/** 获取长度为3 的数组    
		 * direction 是当前角色的方向  
		 * 返回的是数组是 该人物方向下 宠物所应该站立的角度 
		 */ 
		private static function get3LenDegreeArr(direction:int):Array
		{
			var degree:int=DirectionUtil.getDirectionDegree(direction);;
			var arr:Array=[];
			var left:int=degree-60;
			var right:int=degree+60;
			arr.push(left,degree,right);
			return arr;

		}
		
		
		
		
	}
}