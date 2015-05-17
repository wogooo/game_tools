package com.msg.mapScene {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SEnterNewMap extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const MAP_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SEnterNewMap.map_id", "mapId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mapId:int;

		/**
		 *  @private
		 */
		public static const MAP_X:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SEnterNewMap.map_x", "mapX", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mapX:int;

		/**
		 *  @private
		 */
		public static const MAP_Y:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SEnterNewMap.map_y", "mapY", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mapY:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.mapId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.mapX);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.mapY);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var map_id$count:uint = 0;
			var map_x$count:uint = 0;
			var map_y$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (map_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnterNewMap.mapId cannot be set twice.');
					}
					++map_id$count;
					this.mapId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (map_x$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnterNewMap.mapX cannot be set twice.');
					}
					++map_x$count;
					this.mapX = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (map_y$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnterNewMap.mapY cannot be set twice.');
					}
					++map_y$count;
					this.mapY = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
