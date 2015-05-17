package com.msg.pets {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.pets.PetInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SInheritPet extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ERROR_INFO:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SInheritPet.error_info", "errorInfo", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var errorInfo:int;

		/**
		 *  @private
		 */
		public static const PET_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.pets.SInheritPet.pet_info", "petInfo", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.pets.PetInfo; });

		public var petInfo:com.msg.pets.PetInfo;

		/**
		 *  @private
		 */
		public static const REMOVE_PET_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SInheritPet.remove_pet_id", "removePetId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var removePetId:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.errorInfo);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.petInfo);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.removePetId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var error_info$count:uint = 0;
			var pet_info$count:uint = 0;
			var remove_pet_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (error_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SInheritPet.errorInfo cannot be set twice.');
					}
					++error_info$count;
					this.errorInfo = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (pet_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SInheritPet.petInfo cannot be set twice.');
					}
					++pet_info$count;
					this.petInfo = new com.msg.pets.PetInfo();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.petInfo);
					break;
				case 3:
					if (remove_pet_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SInheritPet.removePetId cannot be set twice.');
					}
					++remove_pet_id$count;
					this.removePetId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
