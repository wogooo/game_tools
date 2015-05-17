package com.msg.hero {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.common.AttrInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SHeroAttrChange extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CHANGE_ATTR_ARR:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.hero.SHeroAttrChange.change_attr_arr", "changeAttrArr", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.common.AttrInfo; });

		[ArrayElementType("com.msg.common.AttrInfo")]
		public var changeAttrArr:Array = [];

		/**
		 *  @private
		 */
		public static const POWER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SHeroAttrChange.power", "power", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var power:int;

		/**
		 *  @private
		 */
		public static const POTENTIAL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SHeroAttrChange.potential", "potential", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var potential$field:int;

		private var hasField$0:uint = 0;

		public function clearPotential():void {
			hasField$0 &= 0xfffffffe;
			potential$field = new int();
		}

		public function get hasPotential():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set potential(value:int):void {
			hasField$0 |= 0x1;
			potential$field = value;
		}

		public function get potential():int {
			return potential$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var changeAttrArr$index:uint = 0; changeAttrArr$index < this.changeAttrArr.length; ++changeAttrArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.changeAttrArr[changeAttrArr$index]);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.power);
			if (hasPotential) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, potential$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var power$count:uint = 0;
			var potential$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					this.changeAttrArr.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.common.AttrInfo()));
					break;
				case 2:
					if (power$count != 0) {
						throw new flash.errors.IOError('Bad data format: SHeroAttrChange.power cannot be set twice.');
					}
					++power$count;
					this.power = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: SHeroAttrChange.potential cannot be set twice.');
					}
					++potential$count;
					this.potential = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
