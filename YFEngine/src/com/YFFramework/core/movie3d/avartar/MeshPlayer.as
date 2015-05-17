package com.YFFramework.core.movie3d.avartar
{
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.event.YFEvent;
	
	import flash.display.BitmapData;

	/**控制mesh的材质切换 
	 *   模型动画播放     Mesh目前采用 图片轮播   来播放特效   也就是一张 一张 bitmapData的切换<由于mesh的特殊性，无法使用UV>
	 * @author yefeng
	 *2013-3-24下午5:18:59
	 */
	public class MeshPlayer
	{
		private static const DefaultBitmapData:BitmapData=new BitmapData(2,2,true,0xFFFFFFFF);

		private var _mesh:Mesh;
		private var _meshMovieDataArr:Vector.<MeshMovieData>;
		private var _bitmapTexture:BitmapTexture;
		private var _tweenMeshMoviePlay:TweenMeshMoviePlay;
		
		private var _playComplete:Function;
		private var _playCompleteparam:Object;
		public function MeshPlayer(mesh:Mesh)
		{
			_mesh=mesh;
			initUI();
			addEvents();
		}
		private function initUI():void
		{
			_bitmapTexture=new BitmapTexture(DefaultBitmapData);
			_mesh.material=new TextureMaterial(_bitmapTexture);
			_mesh.material.bothSides=true;
			_tweenMeshMoviePlay=new TweenMeshMoviePlay();
		}
		
		private function addEvents():void
		{
			_tweenMeshMoviePlay.addEventListener(YFEvent.Complete,onMovieComplete);
		}
		private function removeEvents():void
		{
			_tweenMeshMoviePlay.removeEventListener(YFEvent.Complete,onMovieComplete);
		}
			
		private function onMovieComplete(e:YFEvent):void
		{
			if(_playComplete!=null) _playComplete(_playCompleteparam);	
		}
		public function get mesh():Mesh
		{
			return _mesh;
		}
		/**设置材质
		 */		
		public function setMaterial(meshMovieDataArr:Vector.<MeshMovieData>):void
		{
			_meshMovieDataArr=meshMovieDataArr;
		}
		
		private function play(loop:Boolean=true):void
		{
			_tweenMeshMoviePlay.dispose();
			_tweenMeshMoviePlay.initData(updateBitmapTexture,_meshMovieDataArr,loop);
			_tweenMeshMoviePlay.start();
		}
		/**更新材质
		 */		
		protected function updateBitmapTexture(meshMovieData：MeshMovieData):void
		{
			_bitmapTexture.bitmapData=meshMovieData.bitmapData;
			_bitmapTexture.invalidateContent();
		}
		
		public function stop():void
		{
			UpdateManager.Instance.framePer.delFunc(_tweenMeshMoviePlay.update);
			_tweenMeshMoviePlay.stop();
		}
		
		public function start():void
		{
			UpdateManager.Instance.framePer.regFunc(_tweenMeshMoviePlay.update);
		}
		
		public function dispose():void
		{
			removeEvents();
			stop();
			_tweenMeshMoviePlay.dispose();
			_mesh=null;
			_meshMovieDataArr=null;
			_bitmapTexture=null;
			_tweenMeshMoviePlay=null;
			_playComplete=null
			_playCompleteparam=null;

		}
	}
}