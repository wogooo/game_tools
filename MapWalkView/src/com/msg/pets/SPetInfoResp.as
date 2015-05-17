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
	public dynamic final class SPetInfoResp extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PET_INFOS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.pets.SPetInfoResp.pet_infos", "petInfos", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.pets.PetInfo; });

		[ArrayElementType("com.msg.pets.PetInfo")]
		public var petInfos:Array = [];

		/**
		 *  @private
		 */
		public static const PET_OPEN_SLOTS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SPetInfoResp.pet_open_slots", "petOpenSlots", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var petOpenSlots:int;

		/**
		 *  @private
		 */
		public static const FIGHT_PET_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SPetInfoResp.fight_pet_id", "fightPetId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var fightPetId:int;

		/**
		 *  @private
		 */
		public static const PET_AI:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SPetInfoResp.pet_ai", "petAi", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var petAi:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var petInfos$index:uint = 0; petInfos$index < this.petInfos.length; ++petInfos$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.petInfos[petInfos$index]);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.petOpenSlots);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.fightPetId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.petAi);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var pet_open_slots$count:uint = 0;
			var fight_pet_id$count:uint = 0;
			var pet_ai$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					this.petInfos.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.pets.PetInfo()));
					break;
				case 2:
					if (pet_open_slots$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetInfoResp.petOpenSlots cannot be set twice.');
					}
					++pet_open_slots$count;
					this.petOpenSlots = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (fight_pet_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetInfoResp.fightPetId cannot be set twice.');
					}
					++fight_pet_id$count;
					this.fightPetId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (pet_ai$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetInfoResp.petAi cannot be set twice.');
					}
					++pet_ai$count;
					this.petAi = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
