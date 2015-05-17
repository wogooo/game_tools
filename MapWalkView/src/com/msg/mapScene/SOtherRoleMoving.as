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
	public dynamic final class SOtherRoleMoving extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CURRENT_POSTION:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SOtherRoleMoving.current_postion", "currentPostion", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var currentPostion:int;

		/**
		 *  @private
		 */
		public static const PATH:RepeatedFieldDescriptor$TYPE_INT32 = new RepeatedFieldDescriptor$TYPE_INT32("com.msg.mapScene.SOtherRoleMoving.path", "path", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		[ArrayElementType("int")]
		public var path:Array = [];

		/**
		 *  @private
		 */
		public static const SPEED:FieldDescriptor$TYPE_FLOAT = new FieldDescriptor$TYPE_FLOAT("com.msg.mapScene.SOtherRoleMoving.speed", "speed", (3 << 3) | com.netease.protobuf.WireType.FIXED_32_BIT);

		public var speed:Number;

		/**
		 *  @private
		 */
		public static const ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SOtherRoleMoving.id", "id", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var id:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.currentPostion);
			for (var path$index:uint = 0; path$index < this.path.length; ++path$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.path[path$index]);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_32_BIT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_FLOAT(output, this.speed);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.id);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var current_postion$count:uint = 0;
			var speed$count:uint = 0;
			var id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (current_postion$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherRoleMoving.currentPostion cannot be set twice.');
					}
					++current_postion$count;
					this.currentPostion = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if ((tag & 7) == com.netease.protobuf.WireType.LENGTH_DELIMITED) {
						com.netease.protobuf.ReadUtils.readPackedRepeated(input, com.netease.protobuf.ReadUtils.read$TYPE_INT32, this.path);
						break;
					}
					this.path.push(com.netease.protobuf.ReadUtils.read$TYPE_INT32(input));
					break;
				case 3:
					if (speed$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherRoleMoving.speed cannot be set twice.');
					}
					++speed$count;
					this.speed = com.netease.protobuf.ReadUtils.read$TYPE_FLOAT(input);
					break;
				case 4:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherRoleMoving.id cannot be set twice.');
					}
					++id$count;
					this.id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
