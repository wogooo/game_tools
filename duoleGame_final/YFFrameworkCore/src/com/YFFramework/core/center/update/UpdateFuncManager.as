package com.YFFramework.core.center.update
{
	/**@author yefeng
	 * 2013 2013-10-22 下午1:14:26 
	 */
	public class UpdateFuncManager
	{
		private var _arr0:Vector.<Function>;
		private var _arr1:Vector.<Function>;
		private var _arr2:Vector.<Function>;
		
		private var _size0:int;
		private var _size1:int;
		private var _size2:int;
		
		private var _flag:int=0;
		
		private var _renderIndex:int=0;
		
		private var i:int;
		public function UpdateFuncManager()
		{
			_arr0=new Vector.<Function>();
			_arr1=new Vector.<Function>();
			_arr2=new Vector.<Function>();
			_size0=0;
			_size1=0;
			_size2=0;
		}
		public function addFunc(movieFunc:Function):void
		{
			var index0:int=_arr0.indexOf(movieFunc);
			var index1:int=_arr1.indexOf(movieFunc);
			var index2:int=_arr2.indexOf(movieFunc);
			if(index0==-1&&index1==-1&&index2==-1)
			{
				switch(_flag)
				{
					case 0:
						_arr0.push(movieFunc);
						_size0++;
						break;
					case 1:
						_arr1.push(movieFunc);
						_size1++;
						break;
					case 2:
						_arr2.push(movieFunc);
						_size2++;
						break;
				}
				++_flag;
				if(_flag>=3)_flag=_flag%3;
				//				if(_flag==0||_flag==1)
				//				{
				//					_arr0.push(movieFunc);
				//					_size0++;
				//				}
				//				else 
				//				{
				//					_arr1.push(movieFunc);
				//					_size1++;
				//				}
				//				++_flag;
				//				if(_flag>=4)_flag=0;
			}
		}
		public function removeFunc(movieFunc:Function):void
		{
			var index0:int=_arr0.indexOf(movieFunc);
			var index1:int=_arr1.indexOf(movieFunc);
			var index2:int=_arr2.indexOf(movieFunc);
			if(index0!=-1)
			{
				_arr0.splice(index0,1);
				_size0--;
			}
			else if(index1!=-1)
			{
				_arr1.splice(index1,1);
				_size1--;
			}
			else if(index2!=-1)
			{
				_arr2.splice(index2,1);
				_size2--;
			}
			
			var min:int=Math.min(_size0,_size1,_size2);
			if(min==_size0)
			{
				_flag=0;
			}
			else if(min==_size1)
			{
				_flag=1;
			}
			else if(min==_size2)
			{
				_flag=2;
			}
			
			//			if(_size0>=_size1)
			//			{
			//				_flag=2;
			//			}
			//			else 
			//			{
			//				_flag=0;
			//			}
		}
		
		
		public function update():void
		{
			switch(_renderIndex)
			{
				case 0:
					for(i=0;i<_size0;++i)
					{
						_arr0[i]();
					}
					for(i=0;i<_size1;++i)
					{
						_arr1[i]();
					}
					_renderIndex=1;
					break;
				case 1:
					for(i=0;i<_size1;++i)
					{
						_arr1[i]();
					}
					for(i=0;i<_size2;++i)
					{
						_arr2[i]();
					}
					_renderIndex=2;
					break;
				case 2:
					for(i=0;i<_size2;++i)
					{
						_arr2[i]();
					}
					for(i=0;i<_size0;++i)
					{
						_arr0[i]();
					}
					_renderIndex=0;
					break;
			}
		}
	}
}