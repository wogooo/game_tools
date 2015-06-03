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
	public dynamic final class SHeroInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ATTR_ARR:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.hero.SHeroInfo.attr_arr", "attrArr", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.common.AttrInfo; });

		[ArrayElementType("com.msg.common.AttrInfo")]
		public var attrArr:Array = [];

		/**
		 *  @private
		 */
		public static const POWER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SHeroInfo.power", "power", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var power:int;

		/**
		 *  @private
		 */
		public static const WING_LUCKY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SHeroInfo.wing_lucky", "wingLucky", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var wing_lucky$field:int;

		private var hasField$0:uint = 0;

		public function clearWingLucky():void {
			hasField$0 &= 0xfffffffe;
			wing_lucky$field = new int();
		}

		public function get hasWingLucky():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set wingLucky(value:int):void {
			hasField$0 |= 0x1;
			wing_lucky$field = value;
		}

		public function get wingLucky():int {
			return wing_lucky$field;
		}

		/**
		 *  @private
		 */
		public static const MOUNT_LUCKY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SHeroInfo.mount_lucky", "mountLucky", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mount_lucky$field:int;

		public function clearMountLucky():void {
			hasField$0 &= 0xfffffffd;
			mount_lucky$field = new int();
		}

		public function get hasMountLucky():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set mountLucky(value:int):void {
			hasField$0 |= 0x2;
			mount_lucky$field = value;
		}

		public function get mountLucky():int {
			return mount_lucky$field;
		}

		/**
		 *  @private
		 */
		public static const WING_ENHANCE_TIMES:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SHeroInfo.wing_enhance_times", "wingEnhanceTimes", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var wing_enhance_times$field:int;

		public function clearWingEnhanceTimes():void {
			hasField$0 &= 0xfffffffb;
			wing_enhance_times$field = new int();
		}

		public function get hasWingEnhanceTimes():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set wingEnhanceTimes(value:int):void {
			hasField$0 |= 0x4;
			wing_enhance_times$field = value;
		}

		public function get wingEnhanceTimes():int {
			return wing_enhance_times$field;
		}

		/**
		 *  @private
		 */
		public static const WING_MONEY_TIMES:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SHeroInfo.wing_money_times", "wingMoneyTimes", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var wing_money_times$field:int;

		public function clearWingMoneyTimes():void {
			hasField$0 &= 0xfffffff7;
			wing_money_times$field = new int();
		}

		public function get hasWingMoneyTimes():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set wingMoneyTimes(value:int):void {
			hasField$0 |= 0x8;
			wing_money_times$field = value;
		}

		public function get wingMoneyTimes():int {
			return wing_money_times$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var attrArr$index:uint = 0; attrArr$index < this.attrArr.length; ++attrArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.attrArr[attrArr$index]);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.power);
			if (hasWingLucky) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, wing_lucky$field);
			}
			if (hasMountLucky) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mount_lucky$field);
			}
			if (hasWingEnhanceTimes) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, wing_enhance_times$field);
			}
			if (hasWingMoneyTimes) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, wing_money_times$field);
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
			var wing_lucky$count:uint = 0;
			var mount_lucky$count:uint = 0;
			var wing_enhance_times$count:uint = 0;
			var wing_money_times$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					this.attrArr.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.common.AttrInfo()));
					break;
				case 2:
					if (power$count != 0) {
						throw new flash.errors.IOError('Bad data format: SHeroInfo.power cannot be set twice.');
					}
					++power$count;
					this.power = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (wing_lucky$count != 0) {
						throw new flash.errors.IOError('Bad data format: SHeroInfo.wingLucky cannot be set twice.');
					}
					++wing_lucky$count;
					this.wingLucky = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (mount_lucky$count != 0) {
						throw new flash.errors.IOError('Bad data format: SHeroInfo.mountLucky cannot be set twice.');
					}
					++mount_lucky$count;
					this.mountLucky = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (wing_enhance_times$count != 0) {
						throw new flash.errors.IOError('Bad data format: SHeroInfo.wingEnhanceTimes cannot be set twice.');
					}
					++wing_enhance_times$count;
					this.wingEnhanceTimes = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (wing_money_times$count != 0) {
						throw new flash.errors.IOError('Bad data format: SHeroInfo.wingMoneyTimes cannot be set twice.');
					}
					++wing_money_times$count;
					this.wingMoneyTimes = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
