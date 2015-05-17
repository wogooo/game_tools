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
	public dynamic final class SEnhancePet extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ERROR_INFO:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SEnhancePet.error_info", "errorInfo", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var errorInfo:int;

		/**
		 *  @private
		 */
		public static const PET_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SEnhancePet.pet_id", "petId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var petId:int;

		/**
		 *  @private
		 */
		public static const ENHANCE_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SEnhancePet.enhance_level", "enhanceLevel", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var enhanceLevel:int;

		/**
		 *  @private
		 */
		public static const PET_ATTR:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.pets.SEnhancePet.pet_attr", "petAttr", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.pets.SPetAttr; });

		public var petAttr:com.msg.pets.SPetAttr;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.errorInfo);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.petId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.enhanceLevel);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.petAttr);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var error_info$count:uint = 0;
			var pet_id$count:uint = 0;
			var enhance_level$count:uint = 0;
			var pet_attr$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (error_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnhancePet.errorInfo cannot be set twice.');
					}
					++error_info$count;
					this.errorInfo = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (pet_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnhancePet.petId cannot be set twice.');
					}
					++pet_id$count;
					this.petId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (enhance_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnhancePet.enhanceLevel cannot be set twice.');
					}
					++enhance_level$count;
					this.enhanceLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (pet_attr$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnhancePet.petAttr cannot be set twice.');
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
