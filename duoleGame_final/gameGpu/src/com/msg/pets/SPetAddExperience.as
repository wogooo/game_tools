package com.msg.pets {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.pets.SPetLevelup;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SPetAddExperience extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const EXP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SPetAddExperience.exp", "exp", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var exp:int;

		/**
		 *  @private
		 */
		public static const PET_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SPetAddExperience.pet_id", "petId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var petId:int;

		/**
		 *  @private
		 */
		public static const LEVEL_UP:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.pets.SPetAddExperience.level_up", "levelUp", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.pets.SPetLevelup; });

		private var level_up$field:com.msg.pets.SPetLevelup;

		public function clearLevelUp():void {
			level_up$field = null;
		}

		public function get hasLevelUp():Boolean {
			return level_up$field != null;
		}

		public function set levelUp(value:com.msg.pets.SPetLevelup):void {
			level_up$field = value;
		}

		public function get levelUp():com.msg.pets.SPetLevelup {
			return level_up$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.exp);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.petId);
			if (hasLevelUp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, level_up$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var exp$count:uint = 0;
			var pet_id$count:uint = 0;
			var level_up$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (exp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetAddExperience.exp cannot be set twice.');
					}
					++exp$count;
					this.exp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (pet_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetAddExperience.petId cannot be set twice.');
					}
					++pet_id$count;
					this.petId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (level_up$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetAddExperience.levelUp cannot be set twice.');
					}
					++level_up$count;
					this.levelUp = new com.msg.pets.SPetLevelup();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.levelUp);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
