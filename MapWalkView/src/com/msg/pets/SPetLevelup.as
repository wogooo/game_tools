package com.msg.pets {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.pets.SPetAttr;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SPetLevelup extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SPetLevelup.level", "level", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var level:int;

		/**
		 *  @private
		 */
		public static const POTENTIAL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SPetLevelup.potential", "potential", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var potential:int;

		/**
		 *  @private
		 */
		public static const PET_ATTR:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.pets.SPetLevelup.pet_attr", "petAttr", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.pets.SPetAttr; });

		public var petAttr:com.msg.pets.SPetAttr;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.level);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.potential);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.petAttr);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var level$count:uint = 0;
			var potential$count:uint = 0;
			var pet_attr$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetLevelup.level cannot be set twice.');
					}
					++level$count;
					this.level = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetLevelup.potential cannot be set twice.');
					}
					++potential$count;
					this.potential = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (pet_attr$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetLevelup.petAttr cannot be set twice.');
					}
					++pet_attr$count;
					this.petAttr = new com.msg.pets.SPetAttr();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.petAttr);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
