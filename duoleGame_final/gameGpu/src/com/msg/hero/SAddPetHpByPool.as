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
	public dynamic final class SAddPetHpByPool extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ERRO_INFO:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SAddPetHpByPool.erro_info", "erroInfo", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var erroInfo:int;

		/**
		 *  @private
		 */
		public static const PET_HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SAddPetHpByPool.pet_hp", "petHp", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var pet_hp$field:int;

		private var hasField$0:uint = 0;

		public function clearPetHp():void {
			hasField$0 &= 0xfffffffe;
			pet_hp$field = new int();
		}

		public function get hasPetHp():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set petHp(value:int):void {
			hasField$0 |= 0x1;
			pet_hp$field = value;
		}

		public function get petHp():int {
			return pet_hp$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.erroInfo);
			if (hasPetHp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, pet_hp$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var erro_info$count:uint = 0;
			var pet_hp$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (erro_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SAddPetHpByPool.erroInfo cannot be set twice.');
					}
					++erro_info$count;
					this.erroInfo = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (pet_hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SAddPetHpByPool.petHp cannot be set twice.');
					}
					++pet_hp$count;
					this.petHp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
