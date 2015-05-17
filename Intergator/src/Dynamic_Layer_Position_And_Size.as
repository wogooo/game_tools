/* 
Framework Integration Example

Demonstrates :

A demonstration of how to two framework layers can be independently positioned and
resized with the shared Stage3D/Context3D.

In this example, one Starling sprite scene contains a bitmap/transparent checkerboard 
that is centered on the display and is rotated and an Away3D scene is an arrangement of 
cubes on a wireframe grid. Each layer is repositioned and resized within the stage3D
instance. This 3D scene has a hovercontroller attached to it allowing you to rotate 
the scene with the mouse. Note, it mouse control only interacts with the 3D scene.

Clicking the button changes the rendering order of the layers so you can see how they
interact.

This particular example demonstrates how to use the automatic rendering approach of the 
Stage3DProxy class by adding the EnterFrame listener to the 'stage3DProxy' instance. The 
listener method then only needs to manage the render calls as the clear() and present()
methods are automatically called.

Code by Greg Caldwell
greg@geepers.co.uk
http://www.geepers.co.uk

This code is distributed under the MIT License

Copyright (c)  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

 */
package {
	import starling.rootsprites.StarlingCheckerboardSprite;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.Stage3DEvent;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.WireframePlane;
	import away3d.textures.BitmapTexture;

	import starling.core.Starling;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	[SWF(width="800", height="600", frameRate="60")]
	public class Dynamic_Layer_Position_And_Size extends Sprite {
		[Embed(source="../embeds/button.png")]
		private var ButtonBitmap:Class;
		
		// Stage manager and proxy instances
		private var stage3DManager : Stage3DManager;
		private var stage3DProxy : Stage3DProxy;

		// Away3D view instance
		private var away3dView : View3D;
		
		// Camera controllers 
		private var hoverController : HoverController;
				
		// Materials
		private var cubeMaterial : TextureMaterial;

		// Objects
		private var cube1 : Mesh;
		private var cube2 : Mesh;
		private var cube3 : Mesh;
		private var cube4 : Mesh;
		private var cube5 : Mesh;
		
		// Runtime variables
		private var lastPanAngle : Number = 0;
		private var lastTiltAngle : Number = 0;
		private var lastMouseX : Number = 0;
		private var lastMouseY : Number = 0;
		private var mouseDown : Boolean;
		private var renderOrderDesc : TextField;
		private var renderOrder : int = 0;
		private var counter : Number = 0;
		private var s3DWidth : int;
		private var s3DHeight : int;
		private var starlingViewPort : Rectangle;
		
		// Starling instances
		private var starlingCheckerboard:Starling;
				
		// Constants
		private const CHECKERS_CUBES:int = 0;
		private const CUBES_CHECKERS : int = 1;
		
		/**
		 * Constructor
		 */
		public function Dynamic_Layer_Position_And_Size()
		{
			init();
		}
		
		/**
		 * Global initialise function
		 */
		private function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			initProxies();
		}
		
		/**
		 * Initialise the Stage3D proxies
		 */
		private function initProxies():void
		{
			// Define a new Stage3DManager for the Stage3D objects
			stage3DManager = Stage3DManager.getInstance(stage);

			// Create a new Stage3D proxy to contain the separate views
			stage3DProxy = stage3DManager.getFreeStage3DProxy();
			stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			stage3DProxy.antiAlias = 8;
			stage3DProxy.color = 0x0;
			
			s3DWidth = stage3DProxy.width;
			s3DHeight = stage3DProxy.height;
		}

		private function onContextCreated(event : Stage3DEvent) : void {
			initAway3D();
			initStarling();
			initMaterials();
			initObjects();
			initButton();
			initListeners();
		}

	
		/**
		 * Initialise the Away3D views
		 */
		private function initAway3D() : void
		{
			// Create the first Away3D view which holds the cube objects.
			away3dView = new View3D();
			away3dView.stage3DProxy = stage3DProxy;
			away3dView.shareContext = true;

			hoverController = new HoverController(away3dView.camera, null, 45, 30, 1200, 5, 89.999);
			
			addChild(away3dView);
			
			addChild(new AwayStats(away3dView));
		}
		
		/**
		 * Initialise the Starling sprites
		 */
		private function initStarling() : void
		{
			//Create the Starling scene to add the background wall/fireplace. This is positioned on top of the floor scene starting at the top of the screen. It slightly covers the wooden floor layer to avoid any gaps appearing.
			starlingViewPort = stage3DProxy.viewPort.clone();
			starlingCheckerboard = new Starling(StarlingCheckerboardSprite, stage, starlingViewPort, stage3DProxy.stage3D);
		}

		/**
		 * Initialise the materials
		 */
		private function initMaterials() : void {
			//Create a material for the cubes
			var cubeBmd:BitmapData = new BitmapData(128, 128, false, 0x0);
			cubeBmd.perlinNoise(7, 7, 5, 12345, true, true, 7, true);
			cubeMaterial = new TextureMaterial(new BitmapTexture(cubeBmd));
			cubeMaterial.gloss = 20;
			cubeMaterial.ambientColor = 0x808080;
			cubeMaterial.ambient = 1;
		}
		
		private function initObjects() : void {
			// Build the cubes for view 1
			var cG:CubeGeometry = new CubeGeometry(300, 300, 300);
			cube1 = new Mesh(cG, cubeMaterial);
			cube2 = new Mesh(cG, cubeMaterial);
			cube3 = new Mesh(cG, cubeMaterial);
			cube4 = new Mesh(cG, cubeMaterial);
			cube5 = new Mesh(cG, cubeMaterial);
			
			// Arrange them in a circle with one on the center
			cube1.x = -750; 
			cube2.z = -750;
			cube3.x = 750;
			cube4.z = 750;
			cube1.y = cube2.y = cube3.y = cube4.y = cube5.y = 150;
			
			// Add the cubes to view 1
			away3dView.scene.addChild(cube1);
			away3dView.scene.addChild(cube2);
			away3dView.scene.addChild(cube3);
			away3dView.scene.addChild(cube4);
			away3dView.scene.addChild(cube5);
			away3dView.scene.addChild(new WireframePlane(2500, 2500, 20, 20, 0xbbbb00, 1.5, WireframePlane.ORIENTATION_XZ));
		}
		
		/**
		 * Initialise the button to swap the rendering orders
		 */
		private function initButton() : void {
			this.graphics.beginFill(0x0, 0.7);
			this.graphics.drawRect(0, 0, stage.stageWidth, 100);
			this.graphics.endFill();

			var button:Sprite = new Sprite();
			button.x = 130;
			button.y = 5;
			button.addChild(new ButtonBitmap());
			button.addEventListener(MouseEvent.CLICK, onChangeRenderOrder);
			addChild(button);
			
			renderOrderDesc = new TextField();
			renderOrderDesc.defaultTextFormat = new TextFormat("_sans", 11, 0xffff00);
			renderOrderDesc.width = stage.stageWidth;
			renderOrderDesc.x = 300;
			renderOrderDesc.y = 5;
			addChild(renderOrderDesc);
			
			updateRenderDesc();
		}

		/**
		 * Set up the rendering processing event listeners
		 */
		private function initListeners() : void {
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			stage3DProxy.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		/**
		 * The main rendering loop
		 */
		private function onEnterFrame(event : Event) : void {
			// Update the hovercontroller for view 1
			if (mouseDown) {
				hoverController.panAngle = 0.3 * (stage.mouseX - lastMouseX) + lastPanAngle;
				hoverController.tiltAngle = 0.3 * (stage.mouseY - lastMouseY) + lastTiltAngle;
			}

			// Update the scenes
			var starlingCheckerboardSprite:StarlingCheckerboardSprite = StarlingCheckerboardSprite.getInstance();
			if (starlingCheckerboardSprite)
				starlingCheckerboardSprite.update();
			
			// Use the selected rendering order
			if (renderOrder == CHECKERS_CUBES) {

				// Render the Starling animation layer
				starlingCheckerboard.nextFrame();
				
				// Render the Away3D layer
				away3dView.render();

			} else {

				// Render the Away3D layer
				away3dView.render();

				// Render the Starling animation layer
				starlingCheckerboard.nextFrame();
			}
			
			// Reposition the Away3D view layer
			var a3DPosRatio:Number = 0.125 + (Math.sin(counter * 0.01) * 0.125);
			away3dView.x = s3DWidth * a3DPosRatio;
			away3dView.y = s3DHeight * a3DPosRatio;

			// Resize the Away3D view layer
			var a3DSizeRatio:Number = 0.5 + (Math.sin(counter * 0.01) * 0.25);
			away3dView.width = s3DWidth * a3DSizeRatio;
			away3dView.height = s3DHeight * a3DSizeRatio;

			// Reposition the Starling layer
			var sXPosRatio:Number = 0.125 + (Math.sin(-counter * 0.01) * 0.125);
			var sYPosRatio:Number = 0.5 + (Math.sin(-counter * 0.02) * 0.5);
			starlingViewPort.x = s3DWidth * sXPosRatio;
			starlingViewPort.y = (s3DHeight-200) * sYPosRatio;

			// Resize the Away3D Starling layer
			var sSizeRatio:Number = 0.75 + (Math.sin(counter * 0.01) * 0.25);
			starlingViewPort.width = s3DWidth * sSizeRatio;
			starlingViewPort.height = 200;

			counter++;
		}

		/**
		 * Handle the mouse down event and remember details for hovercontroller
		 */
		private function onMouseDown(event : MouseEvent) : void {
			mouseDown = true;
			lastPanAngle = hoverController.panAngle;
			lastTiltAngle = hoverController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
		}

		/**
		 * Clear the mouse down flag to stop the hovercontroller
		 */
		private function onMouseUp(event : MouseEvent) : void {
			mouseDown = false; 
		}

		/**
		 * Swap the rendering order 
		 */
		private function onChangeRenderOrder(event : MouseEvent) : void {
			renderOrder = (renderOrder == CHECKERS_CUBES) ? CUBES_CHECKERS : CHECKERS_CUBES;
 			
			updateRenderDesc();
		}		

		/**
		 * Change the text describing the rendering order
		 */
		private function updateRenderDesc() : void {
			var txt:String = "Demo of integrating two framework layers onto a stage3D instance. This demonstrates the\n";
			txt += "resizing and positioning of layers. Click the button to the left to swap the layers around.\n";
			txt += "EnterFrame is attached to the Stage3DProxy - clear()/present() are handled automatically\n";
			txt += "Mouse down and drag to rotate the Away3D scene.\n\n";
			switch (renderOrder) {
				case CHECKERS_CUBES : txt += "Render Order (first:behind to last:in-front) : Checkers > Cubes"; break;
				case CUBES_CHECKERS : txt += "Render Order (first:behind to last:in-front) : Cubes > Checkers"; break;
			}
			renderOrderDesc.text = txt;
		}
	}
}
