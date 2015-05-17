package com.YFFramework.core.movie3d.avartar
{
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.nodes.AnimationNodeBase;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/**克隆   Mesh带有新的骨骼数据
	 * @author yefeng
	 *2013-3-24下午6:08:24
	 */
	public class MeshUtil
	{
		public function MeshUtil()
		{
		}

		/**克隆骨骼数据 返回新的骨骼数据
		 * newMaterial   不同的Animator不能共用材质 ,新的材质    材质是不能共用的
		 */ 
		public static function cloneMesh(mesh:Mesh,newMaterial:MaterialBase=null):Mesh
		{
			var meshClone:Mesh=mesh.clone() as Mesh;
			var animatorset:SkeletonAnimationSet=new SkeletonAnimationSet(3);
			var cloneAnimator:SkeletonAnimator=new SkeletonAnimator(animatorset,SkeletonAnimator(mesh.animator).skeleton);
			for each(var animationNode:AnimationNodeBase in SkeletonAnimationSet(mesh.animator.animationSet).animations)
			{
				animatorset.addAnimation(animationNode);
			}
			cloneAnimator.updatePosition=false; ///不要自动更新位置
			meshClone.material=newMaterial;
			meshClone.animator=cloneAnimator;
			return meshClone;
		}
		
		/**绑定骨骼的骨骼 ，做粒子跟随 某块骨头    教程  http://bbs.9ria.com/thread-146447-1-1.html
		 * 返回的该骨头的位置
		 */		
		public static function getBoneIndex(animator:SkeletonAnimator,boneName:String):int
		{
			///获取要绑定的骨头索引
			var index:int=animator.skeleton.jointIndexFromName(boneName);
			return index;
		}
		/**获取当前姿势下  该骨头的坐标 ， 注意 粒子跟随 时  该方法需要不断更新  因为 姿势在不断变化
		 *  返回的该骨头的位当前位置
		 * 粒子的坐标 就等于 当前坐标的位置    该方法需要在enterFrame里面不断的调用 来更新骨头的新位置 以此来刷新粒子的新位置
		 * 教程  http://bbs.9ria.com/thread-146447-1-1.html
		 */ 
		public static function getBonePosition(boneIndex:int,animator:SkeletonAnimator):Vector3D
		{
			///获取 骨头索引为boneIndex的   当前矩阵
			var mat:Matrix3D = animator.globalPose.jointPoses[boneIndex].toMatrix3D();
			return mat.position;
		}
			
		
		
		
	}
}