package com.YFFramework.core.movie3d.avartar
{
	/**@author yefeng
	 *2013-3-18下午9:47:49
	 */
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	
	public class MovieClip3D extends Mesh
	{
		
		public function MovieClip3D(geometry : Geometry, material : MaterialBase = null)
		{
			super(geometry, material);
		}
	}
}