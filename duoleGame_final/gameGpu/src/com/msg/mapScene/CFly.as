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
	public dynamic final class CFly extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const SCENE_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.CFly.scene_id", "sceneId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var sceneId:int;

		/**
		 *  @private
		 */
		public static const TAG_X:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.CFly.tag_x", "tagX", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var tagX:int;

		/**
		 *  @private
		 */
		public static const TAG_Y:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.CFly.tag_y", "tagY", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var tagY:int;

		/**
		 *  @private
		 */
		public static const ITEM_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.CFly.item_pos", "itemPos", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var itemPos:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.sceneId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.tagX);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.tagY);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.itemPos);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var scene_id$count:uint = 0;
			var tag_x$count:uint = 0;
			var tag_y$count:uint = 0;
			var item_pos$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (scene_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CFly.sceneId cannot be set twice.');
					}
					++scene_id$count;
					this.sceneId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (tag_x$count != 0) {
						throw new flash.errors.IOError('Bad data format: CFly.tagX cannot be set twice.');
					}
					++tag_x$count;
					this.tagX = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (tag_y$count != 0) {
						throw new flash.errors.IOError('Bad data format: CFly.tagY cannot be set twice.');
					}
					++tag_y$count;
					this.tagY = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (item_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CFly.itemPos cannot be set twice.');
					}
					++item_pos$count;
					this.itemPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
