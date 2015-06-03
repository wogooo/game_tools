package com.msg.pets {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.common.SkillInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CInheritPet extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const MAIN_PET_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.CInheritPet.main_pet_id", "mainPetId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mainPetId:int;

		/**
		 *  @private
		 */
		public static const DEPUTY_PET_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.CInheritPet.deputy_pet_id", "deputyPetId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var deputyPetId:int;

		/**
		 *  @private
		 */
		public static const KEEP_SKILLS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.pets.CInheritPet.keep_skills", "keepSkills", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.common.SkillInfo; });

		[ArrayElementType("com.msg.common.SkillInfo")]
		public var keepSkills:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.mainPetId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.deputyPetId);
			for (var keepSkills$index:uint = 0; keepSkills$index < this.keepSkills.length; ++keepSkills$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.keepSkills[keepSkills$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var main_pet_id$count:uint = 0;
			var deputy_pet_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (main_pet_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CInheritPet.mainPetId cannot be set twice.');
					}
					++main_pet_id$count;
					this.mainPetId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (deputy_pet_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CInheritPet.deputyPetId cannot be set twice.');
					}
					++deputy_pet_id$count;
					this.deputyPetId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					this.keepSkills.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.common.SkillInfo()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
