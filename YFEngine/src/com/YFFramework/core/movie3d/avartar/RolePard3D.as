package com.YFFramework.core.movie3d.avartar
{
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.transitions.IAnimationTransition;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	
	import flash.display.BitmapData;

	/**@author yefeng
	 *2013-4-14下午9:02:58
	 */
	public class RolePard3D extends AbsView3D
	{
		public var rolePart3DData:RolePart3DData;
		public var skeletonAniator:SkeletonAnimator;
		
		private var _bitmapTexture:BitmapTexture;
		
		private var _textureMaterial:TextureMaterial;
		public function RolePard3D()
		{
			super();
			_textureMaterial=new TextureMaterial();
		}
		public function initMesh(rolePart3DData:RolePart3DData):void
		{
			this.rolePart3DData=rolePart3DData;
			addChild(rolePart3DData.mesh);
			rolePart3DData.mesh.x=rolePart3DData.x;
			rolePart3DData.mesh.y=rolePart3DData.y;
			rolePart3DData.mesh.z=rolePart3DData.z;
			rolePart3DData.mesh.scale(rolePart3DData.scale);
			rolePart3DData.mesh.rotationY=rolePart3DData.rotationY;
			skeletonAniator=SkeletonAnimator(rolePart3DData.mesh.animator);
		}
		public function play(name : String, transition : IAnimationTransition = null, offset : Number = NaN):void
		{
			skeletonAniator.play(name,transition,offset);
		}
		
		
		public function updateMaterial(bitmapData:BitmapData):void
		{
			disposeBitmapTexture();
			_bitmapTexture=new BitmapTexture(bitmapData);
			_textureMaterial.texture=_bitmapTexture;
			rolePart3DData.mesh.material=_textureMaterial;
		}
		
		private function disposeBitmapTexture():void
		{
			if(_bitmapTexture)
			{
				_bitmapTexture.dispose();
				_bitmapTexture=null;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			disposeBitmapTexture();
			_textureMaterial.dispose();
			_textureMaterial=null;
			if(rolePart3DData)	rolePart3DData.dispose();
			rolePart3DData=null;
			skeletonAniator=null;
		}
			
		
		
		
		
		
	}
}