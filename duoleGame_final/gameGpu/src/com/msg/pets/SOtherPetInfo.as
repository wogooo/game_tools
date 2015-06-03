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
	public dynamic final class SOtherPetInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PET_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.pets.SOtherPetInfo.pet_info", "petInfo", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.pets.PetInfo; });

		private var pet_info$field:com.msg.pets.PetInfo;

		public function clearPetInfo():void {
			pet_info$field = null;
		}

		public function get hasPetInfo():Boolean {
			return pet_info$field != null;
		}

		public function set petInfo(value:com.msg.pets.PetInfo):void {
			pet_info$field = value;
		}

		public function get petInfo():com.msg.pets.PetInfo {
			return pet_info$field;
		}

		/**
		 *  @private
		 */
		public static const CODE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SOtherPetInfo.code", "code", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var code:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasPetInfo) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, pet_info$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.code);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var pet_info$count:uint = 0;
			var code$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (pet_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherPetInfo.petInfo cannot be set twice.');
					}
					++pet_info$count;
					this.petInfo = new com.msg.pets.PetInfo();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.petInfo);
					break;
				case 2:
					if (code$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherPetInfo.code cannot be set twice.');
					}
					++code$count;
					this.code = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
