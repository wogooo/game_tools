package com.YFFramework.core.yf2d.extension
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.ATFMovieData;
	import com.YFFramework.core.yf2d.extension.face.IYF2dMovie;

	/**2012-11-22 上午11:21:25
	 *@author yefeng
	 */
	public class RolePart2DView extends ATFMovieClip implements IYF2dMovie
	{
		
		public function RolePart2DView()
		{
			super();
		}
		override protected function onPlayComplete(e:YFEvent):void
		{
			// TODO Auto Generated method stub
			_activeAction=-1;
			super.onPlayComplete(e);
		}
		/**
		 * 
		 * @param resetPlay    表示重复播放 如果为false表示不进行重复播放   true表示进行重复播放 
		 * 
		 */
		override public function play(action:int, direction:int=-1, loop:Boolean=true, completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			var realDirection:int;
			var realAction:int;
			if(direction==-1) direction=_activeDirection;
			realDirection=direction;
			realAction=action;
			if(resetPlay) super.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			else  // 在播放相同动作时不在进行重复播放
			{
				if(actionDataAtk_1==null&&action==TypeAction.SpecialAtk_1)  //当为特殊攻击动作时  但是  特殊攻击数据不存在时  用普通攻击动作代替
				{
					action=TypeAction.Attack;
				}
				else if(actionDataFightStand==null&&action==TypeAction.FightStand)//当为战斗待机动作时  但是  战斗待机数据不存在时  用待机动作代替
				{
					action=TypeAction.Stand;
				}
				else if(actionDataFight==null&&action==TypeAction.Attack) //如果为攻击
				{
					action=TypeAction.Stand;
				}
				else if(actionDataInjureDead==null&&(action==TypeAction.Injure)) //action==TypeAction.Dead||    //如果 为 受击 或者死亡
				{
					action=TypeAction.Stand;
				}
				var scaleX:Number=1;
				if(action!=_activeAction||direction!=_activeDirection)
				{
					_completeFunc=completeFunc;
					_completeParam=completeParam;
					if(direction>5)
					{
						scaleX=-1;
						switch(direction)
						{
							case TypeDirection.LeftDown:
								direction=TypeDirection.RightDown
								break;
							case TypeDirection.Left:
								direction=TypeDirection.Right;
								break;
							case TypeDirection.LeftUp:
								direction=TypeDirection.RightUp;
								break;
						}
					}
					else if(direction>0)
					{
						scaleX=1;
					}
					var movieData:ATFMovieData;
					if(action<=2&&actionDataStandWalk)  //普通  动作   包含普通攻击动作
					{
						if(actionDataStandWalk.dataDict[action])
						{
							movieData=actionDataStandWalk.dataDict[action][direction];
							if(!movieData)  // movieData不存在 
							{
								movieData=getUableMovieData(actionDataStandWalk,action,direction);
							}
//							if(!movieData)  // movieData不存在 
//							{
//								if(actionDataStandWalk.getDirectionArr(action).length==1)  //只有一个方向
//								{
//									direction=actionDataStandWalk.getDirectionArr(action)[0];
//									if(direction<=5)
//									{
//										scaleX=1;
//									}
//									else 
//									{
//										var copyObj:Object=TypeDirection.getCopyDirection(direction);
//										scaleX=copyObj.scaleX;
//										direction=copyObj.direction;
//									}
//									movieData=actionDataStandWalk.dataDict[action][direction];
//								}
//							}
							if(movieData)
							{
								var reUseIndex:Boolean=false;
								if(action==_activeAction&&direction!=_activeDirection)reUseIndex=true
								playInit(movieData,scaleX,loop,reUseIndex);
							}
						}
					}
					else if(action==TypeAction.Attack&&actionDataFight)  //普通攻击
					{
						if(actionDataFight.dataDict[action])
						{
							movieData=actionDataFight.dataDict[action][direction];
							if(!movieData)  // movieData不存在 
							{
								movieData=getUableMovieData(actionDataFight,action,direction);
							}
							if(movieData)
							{
								playInit(movieData,scaleX,loop);
							}
						}
					}
					else if((action==TypeAction.Injure||action==TypeAction.Dead)&&actionDataInjureDead)  //受击死亡
					{
						if(actionDataInjureDead)        //死亡的时候可能没有数据
						{
							if(actionDataInjureDead.dataDict[action])
							{
								movieData=actionDataInjureDead.dataDict[action][direction];
								if(!movieData)
								{
									movieData=getUableMovieData(actionDataInjureDead,action,direction);
								}

								if(movieData)
								{
									playInit(movieData,scaleX,loop);
								}
//								else 
//								{
//									direction=actionDataInjureDead.getDirectionArr(action)[0];
//									if(direction<=5)
//									{
//										scaleX=1;
//									}
//									else 
//									{
//										var myinjureObj:Object=TypeDirection.getCopyDirection(direction);
//										scaleX=myinjureObj.scaleX;
//										direction=myinjureObj.direction;
//									}
//									movieData=actionDataInjureDead.dataDict[action][direction];
//									if(movieData)
//									{
//										playInit(movieData,scaleX,loop);
//									}
//								}
							}
							else if(actionDataInjureDead.dataDict[TypeAction.Injure]) //如果没有死亡动作 但是有受击动作  
							{
								movieData=actionDataInjureDead.dataDict[TypeAction.Injure][direction];
								if(!movieData)
								{
									movieData=getUableMovieData(actionDataInjureDead,action,direction);
								}
								if(movieData)
								{
									playInit(movieData,scaleX,loop);
								}
							}
						}
						
					}
					else if(action==TypeAction.SpecialAtk_1)  //特殊 攻击动作 1
					{
						if(actionDataAtk_1.dataDict[action])
						{
							movieData=actionDataAtk_1.dataDict[action][direction];
							if(!movieData)
							{
								movieData=getUableMovieData(actionDataAtk_1,action,direction);
							}
							if(movieData)
							{
								playInit(movieData,scaleX,loop);
							}
						}
					}
					else if(action==TypeAction.FightStand) //  战斗待机
					{
						if(actionDataFightStand.dataDict[action])
						{
							movieData=actionDataFightStand.dataDict[action][direction];
							if(!movieData)
							{
								movieData=getUableMovieData(actionDataFightStand,action,direction);
							}
							if(movieData)
							{
								playInit(movieData,scaleX,loop);
							}
						}
					}
					
				}

			}
//			_activeAction=action;
			_activeAction=realAction;
			_activeDirection=realDirection;
		}
		override public function disposeToPool():void
		{
			super.disposeToPool();
			checkAlpha=true;
		}
	}
}