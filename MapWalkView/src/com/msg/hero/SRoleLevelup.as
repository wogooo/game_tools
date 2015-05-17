package com.msg.hero {
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
	public dynamic final class SRoleLevelup extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SRoleLevelup.level", "level", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var level:int;

		/**
		 *  @private
		 */
		public static const HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SRoleLevelup.hp", "hp", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var hp:int;

		/**
		 *  @private
		 */
		public static const MP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SRoleLevelup.mp", "mp", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mp:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.level);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.hp);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.mp);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var level$count:uint = 0;
			var hp$count:uint = 0;
			var mp$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SRoleLevelup.level cannot be set twice.');
					}
					++level$count;
					this.level = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SRoleLevelup.hp cannot be set twice.');
					}
					++hp$count;
					this.hp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (mp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SRoleLevelup.mp cannot be set twice.');
					}
					++mp$count;
					this.mp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
