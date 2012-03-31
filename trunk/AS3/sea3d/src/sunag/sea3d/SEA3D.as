/* Copyright (C) 2012 Sunag Entertainment
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>. */

package sunag.sea3d
{
	import flash.utils.ByteArray;
	
	import sunag.sea.SEA;
	import sunag.sea.SEAEvent;
	import sunag.sea.SEAObject;
	import sunag.sea3d.bridge.Bridge;

	public class SEA3D extends SEA
	{
		private var _bridge:Bridge;
		private static const _typeClass:Array = (function():Array
		{
			var r:Array = [];
			
			r[SEABitmap.TYPE] = SEABitmap;
			r[SEATexture.TYPE] = SEATexture;
			r[SEAMaterial.TYPE] = SEAMaterial;
			r[SEAAnimation.TYPE] = SEAAnimation;
			r[SEASkeletonAnimation.TYPE] = SEASkeletonAnimation;
			r[SEAMesh.TYPE] = SEAMesh;			
			r[SEASkeletonMesh.TYPE] = SEASkeletonMesh;
			r[SEACameraTarget.TYPE] = SEACameraTarget;
			r[SEACameraFree.TYPE] = SEACameraFree;
			r[SEALightFree.TYPE] = SEALightFree;
			r[SEALightTarget.TYPE] = SEALightTarget;
			r[SEALightPoint.TYPE] = SEALightPoint;
			r[SEAEnvironment.TYPE] = SEAEnvironment;
			r[SEAHelper.TYPE] = SEAHelper;
			
			return r;
		})();
		
		public function SEA3D(bridge:Bridge)
		{
			_bridge = bridge;	
			addEventListener(SEAEvent.COMPLETE_OBJECT, onCompleteObject);
		}
		
		override public function load(bytes:ByteArray):void
		{
			bytes.position = 0;
			
			readHead(bytes);
			
			if (type !== "3D:1.0")
				throw new Error("Invalid version.");
			
			readBody(bytes);
		}
		
		override protected function process(name:String, type:String, data:ByteArray):SEAObject
		{			
			return new _typeClass[type](name, data);
		}
		
		public function get bridge():Bridge
		{
			return _bridge;
		}
		
		private function onCompleteObject(e:SEAEvent):void
		{
			bridge.read(e.object);
		}
	}
}