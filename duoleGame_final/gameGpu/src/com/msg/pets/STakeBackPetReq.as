package com.msg.pets {
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
	public dynamic final class STakeBackPetReq extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PET_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.STakeBackPetReq.pet_id", "petId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var petId:int;

		/**
		 *  @private
		 */
		public static const HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.STakeBackPetReq.hp", "hp", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var hp:int;

		/**
		 *  @private
		 */
		public static const IS_DEAD:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.pets.STakeBackPetReq.is_dead", "isDead", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var isDead:Boolean;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.petId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.hp);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, this.isDead);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var pet_id$count:uint = 0;
			var hp$count:uint = 0;
			var is_dead$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (pet_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: STakeBackPetReq.petId cannot be set twice.');
					}
					++pet_id$count;
					this.petId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: STakeBackPetReq.hp cannot be set twice.');
					}
					++hp$count;
					this.hp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (is_dead$count != 0) {
						throw new flash.errors.IOError('Bad data format: STakeBackPetReq.isDead cannot be set twice.');
					}
					++is_dead$count;
					this.isDead = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
