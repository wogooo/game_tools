package com.msg.mount_pro {
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
	public dynamic final class MountAttr extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PHYSIQUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mount_pro.MountAttr.physique", "physique", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var physique:int;

		/**
		 *  @private
		 */
		public static const STRENGTH:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mount_pro.MountAttr.strength", "strength", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var strength:int;

		/**
		 *  @private
		 */
		public static const AGILITY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mount_pro.MountAttr.agility", "agility", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var agility:int;

		/**
		 *  @private
		 */
		public static const INTELLIGENCE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mount_pro.MountAttr.intelligence", "intelligence", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var intelligence:int;

		/**
		 *  @private
		 */
		public static const SPIRIT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mount_pro.MountAttr.spirit", "spirit", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var spirit:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.physique);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.strength);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.agility);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.intelligence);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.spirit);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var physique$count:uint = 0;
			var strength$count:uint = 0;
			var agility$count:uint = 0;
			var intelligence$count:uint = 0;
			var spirit$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (physique$count != 0) {
						throw new flash.errors.IOError('Bad data format: MountAttr.physique cannot be set twice.');
					}
					++physique$count;
					this.physique = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (strength$count != 0) {
						throw new flash.errors.IOError('Bad data format: MountAttr.strength cannot be set twice.');
					}
					++strength$count;
					this.strength = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (agility$count != 0) {
						throw new flash.errors.IOError('Bad data format: MountAttr.agility cannot be set twice.');
					}
					++agility$count;
					this.agility = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (intelligence$count != 0) {
						throw new flash.errors.IOError('Bad data format: MountAttr.intelligence cannot be set twice.');
					}
					++intelligence$count;
					this.intelligence = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (spirit$count != 0) {
						throw new flash.errors.IOError('Bad data format: MountAttr.spirit cannot be set twice.');
					}
					++spirit$count;
					this.spirit = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
