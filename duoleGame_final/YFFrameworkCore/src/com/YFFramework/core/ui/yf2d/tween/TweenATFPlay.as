package com.YFFramework.core.ui.yf2d.tween
{
	import com.YFFramework.core.event.YFDispather;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.yf2d.data.ATFMovieData;
	
	import flash.utils.getTimer;

	public class TweenATFPlay extends YFDispather
	{
		private var loop:Boolean;
		private var _playData:ATFMovieData;
		
		/**是否已经播放
		 */
		private var _isStart:Boolean;
		private var _playIndex:int=0;
		
		private var _position:Number;
		private var _timer:Number;
		private var _playFunc:Function;
		
		/**用于镜像贴图
		 */ 
		private var _scaleX:Number;
		
		
		private var arrLen:int;
		/** 时间差值 
		 */		
		private var dif:Number;
		/**是否能进行播放
		 */		
		private var _canPlay:Boolean;
		
		/**  播放BitmapDataEx对象  
		 */		
		public function TweenATFPlay()
		{
		}
		
		/**playData是  playFunc的参数   playFunc是 updateTextureData
		 */
		public function  initData(playData:ATFMovieData,scaleX:Number,loop:Boolean=true):void
		{
			_playData=playData;
			_scaleX=scaleX;
			_isStart=false;
			_timer=0;
			_position=0;
			this.loop=loop;
			arrLen=playData.dataArr.length;
		}
		public function setPlayFunc(playFunc:Function):void
		{
			_playFunc=playFunc;
		}
		public function start(playIndex:int=0):void
		{
			if(_playData)
			{
				if(_playData.dataArr)
				{
					_playIndex=playIndex;
					if(_playIndex>=arrLen)_playIndex=0;
					_isStart=true;
					_timer=getTimer();
					_canPlay=false;
					_playFunc(_playData.dataArr[_playIndex],_scaleX);
				}
			}
		}
		public function getPlayIndex():int
		{
			return _playIndex;
		}
		/**  继续播放 在原来的基础上继续播放
		 */		
		public function  continuePlay():void
		{
			_isStart=true;
			_timer=getTimer();
			//			play();
			_playFunc(_playData.dataArr[_playIndex],_scaleX);
		}
		public function stop():void
		{
			_isStart=false;
		}
		
		public function nextPlay():void
		{
			gotoAndStop((_playIndex+1)%arrLen)
		}
		public function prePlay():void
		{
			gotoAndStop((_playIndex-1+arrLen)%arrLen);
		}
		
		public function  gotoAndStop(index:int):void
		{
			start(index);
			stop();
		}
		
		
		
		
		/**更新   理论上的 
		 */
		//		public function update():void
		//		{
		//			if(_isStart)
		//			{
		//				dif=getTimer()-_timer;
		//				_position +=dif;
		//				_timer=getTimer();
		//				///循环   
		//				while(_position>=frameRate*_playData.dataArr[_playIndex].delay)
		//				{
		//					if(_playIndex<arrLen)
		//					{
		//						_position -=frameRate*_playData.dataArr[_playIndex].delay;
		//						++_playIndex;
		//						if(loop&&_playIndex>=arrLen)
		//						{
		//							_playIndex=_playIndex%arrLen;
		//							
		//						}
		//						else if(_playIndex>=arrLen)
		//						{
		//							dispose();
		//							dispatchEventWith(YFEvent.Complete);
		//							return ;
		//						}
		//					}
		//					else 
		//					{
		//						dispose();
		//						dispatchEventWith(YFEvent.Complete);
		//						return;
		//					}
		//				}
		//				play();	 /// 移到外面调用
		//			}
		//		}
		/** 因为  frameRate  ==1  所以取巧方法  去掉frameRate
		 */		
		public function update():void
		{
			if(_isStart&&_playData&&_playData.isDispose==false)
			{
				dif=getTimer()-_timer;
				_position +=dif;
				_timer=getTimer();
				///循环   
				while(_position>=_playData.dataArr[_playIndex].delay)
				{
					if(_playIndex<arrLen)
					{
						_position -=_playData.dataArr[_playIndex].delay;
						++_playIndex;
						_canPlay=true;
						if(loop&&_playIndex>=arrLen)
						{
							_playIndex=_playIndex%arrLen;
							
						}
						else if(_playIndex>=arrLen)
						{
							dispose();
							dispatchEventWith(YFEvent.Complete);
							return ;
						}
					}
					else 
					{
						dispose();
						dispatchEventWith(YFEvent.Complete);
						return;
					}
				}
				if(_canPlay)
				{
					//					play();	 /// 移到外面调用
					_playFunc(_playData.dataArr[_playIndex],_scaleX);
					_canPlay=false;
				}
				
			}
		}
		
		
		//		private function play():void
		//		{
		//			_playFunc(_playData.dataArr[_playIndex],_scaleX);
		//		}
		
		public function dispose():void
		{
			_playData=null;
			_isStart=false;
			//			loop=false
			//			
			//			_position=0;
			//			_timer=0;
			//			arrLen=0;
		}
	}
}