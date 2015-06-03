package com.msg.rank_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.rank_pro.PetInfo;
	import com.msg.item.CharacterEquip;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SRankPlayOrPetInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const EQUIP_INFO:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.rank_pro.SRankPlayOrPetInfo.equip_info", "equipInfo", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.item.CharacterEquip; });

		[ArrayElementType("com.msg.item.CharacterEquip")]
		public var equipInfo:Array = [];

		/**
		 *  @private
		 */
		public static const PET_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.rank_pro.SRankPlayOrPetInfo.pet_info", "petInfo", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.rank_pro.PetInfo; });

		private var pet_info$field:com.msg.rank_pro.PetInfo;

		public function clearPetInfo():void {
			pet_info$field = null;
		}

		public function get hasPetInfo():Boolean {
			return pet_info$field != null;
		}

		public function set petInfo(value:com.msg.rank_pro.PetInfo):void {
			pet_info$field = value;
		}

		public function get petInfo():com.msg.rank_pro.PetInfo {
			return pet_info$field;
		}

		/**
		 *  @private
		 */
		public static const CHARACTER_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.SRankPlayOrPetInfo.character_id", "characterId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var character_id$field:int;

		private var hasField$0:uint = 0;

		public function clearCharacterId():void {
			hasField$0 &= 0xfffffffe;
			character_id$field = new int();
		}

		public function get hasCharacterId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set characterId(value:int):void {
			hasField$0 |= 0x1;
			character_id$field = value;
		}

		public function get characterId():int {
			return character_id$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var equipInfo$index:uint = 0; equipInfo$index < this.equipInfo.length; ++equipInfo$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.equipInfo[equipInfo$index]);
			}
			if (hasPetInfo) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, pet_info$field);
			}
			if (hasCharacterId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, character_id$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var pet_info$count:uint = 0;
			var character_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					this.equipInfo.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.item.CharacterEquip()));
					break;
				case 2:
					if (pet_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SRankPlayOrPetInfo.petInfo cannot be set twice.');
					}
					++pet_info$count;
					this.petInfo = new com.msg.rank_pro.PetInfo();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.petInfo);
					break;
				case 3:
					if (character_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SRankPlayOrPetInfo.characterId cannot be set twice.');
					}
					++character_id$count;
					this.characterId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
