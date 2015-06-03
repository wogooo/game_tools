package com.YFFramework.core.world.movie.player.utils
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.utils.math.YFMath;

	/**
	 * 得到方向
	 * @author yefeng
	 *2012-4-22下午2:12:31
	 */
	public class DirectionUtil
	{
		
		/**分割角度      [-segment,segment]为右方向 以此类推
		 */
		private static const Segment:Number=22.5;
		
		private static const SegmentOffset:Number=4;

		public static const _0_Segent:Number=Segment-SegmentOffset;
		
		private static const _360__Segment:Number=360-(Segment-SegmentOffset);
		private static const _90__Segment:Number=90-(Segment-SegmentOffset);
		
		private static const _90_Segent:Number=90+Segment-SegmentOffset;
		private static const  _180__Segment:Number=180-(Segment-SegmentOffset);
		private static const _180_Segment:Number=180+Segment-SegmentOffset;
		
		private static const _270__Segement:Number=270-(Segment-SegmentOffset);
		
		private static const _270_Segement:Number=270+Segment-SegmentOffset;
		
		public function DirectionUtil()
		{
		}

		
	
		
		public  static function getDirection(startX:Number,startY:Number,endX:Number,endY:Number):int
		{
			var direction:int;
			if(endX!=startX)
			{
				// 15度 最佳  
				var hudu:Number=Math.atan2(endY-startY+0.001,endX-startX+0.001);
				var jiaodu:Number=hudu*180/Math.PI;
				//  以 15度 为分割线
				if(jiaodu<0)
				{
					jiaodu +=360;
				}
				if(jiaodu<=_0_Segent||jiaodu>=_360__Segment)
				{
					return   TypeDirection.Right;//右 
				}
				else if(jiaodu>=_0_Segent&&jiaodu<=_90__Segment)
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
		 
		/** 获取角度
		 * jiaodu  是角度
		 */		
//		public static function getDirectionByDegree(jiaodu:Number):int
//		{
//			if(jiaodu<=Segment||jiaodu>=_360__Segment)
//			{
//				return   TypeDirection.Right;//右 
//			}
//			else if(jiaodu>=Segment&&jiaodu<=_90__Segment)
//			{
//				return  TypeDirection.RightDown ;//右下
//			}
//			else if(jiaodu>=_90__Segment&&jiaodu<=_90_Segent)
//			{
//				return TypeDirection.Down;//下
//			}
//			else if(jiaodu>=_90_Segent&&jiaodu<=_180__Segment)
//			{
//				return  TypeDirection.LeftDown;//左下
//			}
//			else if(jiaodu>=_180__Segment&&jiaodu<=_180_Segment)
//			{
//				return TypeDirection.Left;//左
//			}
//			else if(jiaodu>=_180_Segment&&jiaodu<=_270__Segement)
//			{
//				return TypeDirection.LeftUp ;//左上
//			}
//			else if(jiaodu>=_270__Segement&&jiaodu<=_270_Segement)    ///上
//			{ 
//				return TypeDirection.Up;
//			}
//			else if(jiaodu>=_270_Segement&&jiaodu<=_360__Segment) //右上
//			{
//				return TypeDirection.RightUp;
//			}
//			return TypeDirection.Down;
//		}
		
		
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
		
		/**判断   对方角色是否在以自己为原点的扇形范围内  direction 是自己 主角的 方向   圆形 范围半径 radius jiaodu 为扇形的夹角
		 * otherX otherY  对方的 x  y  坐标
		 */		
		public static function isInSector(heroCenterX:int,heroCenterY:int,direction:int,radius:int,jiaodu:int,otherCenterX:int,otherCenterY:int):Boolean
		{
			///获取主角的角度
			var dis:Number=YFMath.distance(heroCenterX,heroCenterY,otherCenterX,otherCenterY);
			if(dis<=radius)  ///在圆内
			{
				var heroDegree:int=getDirectionDegree(direction);
				var line1:Number=heroDegree+jiaodu*0.5; ///大的一条线的角度
				var line2:Number=heroDegree-jiaodu*0.5 ;//小的一条线的角度
				var otherRoleJiaodu:Number=YFMath.getDegree(heroCenterX,heroCenterY,otherCenterX,otherCenterY); ///其他角色的角度
				if((otherRoleJiaodu-line1)*(otherRoleJiaodu-line2)<=0) return true;  ///在扇形范围内
			}
			return false
		}
		
	}
}