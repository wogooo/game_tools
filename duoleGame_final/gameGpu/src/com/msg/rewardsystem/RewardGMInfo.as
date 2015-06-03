package com.msg.rewardsystem {
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
	public dynamic final class RewardGMInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TEMPLATE_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rewardsystem.RewardGMInfo.template_id", "templateId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var template_id$field:int;

		private var hasField$0:uint = 0;

		public function clearTemplateId():void {
			hasField$0 &= 0xfffffffe;
			template_id$field = new int();
		}

		public function get hasTemplateId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set templateId(value:int):void {
			hasField$0 |= 0x1;
			template_id$field = value;
		}

		public function get templateId():int {
			return template_id$field;
		}

		/**
		 *  @private
		 */
		public static const NUM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rewardsystem.RewardGMInfo.num", "num", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var num$field:int;

		public function clearNum():void {
			hasField$0 &= 0xfffffffd;
			num$field = new int();
		}

		public function get hasNum():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set num(value:int):void {
			hasField$0 |= 0x2;
			num$field = value;
		}

		public function get num():int {
			return num$field;
		}

		/**
		 *  @private
		 */
		public static const TEMPLATE_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rewardsystem.RewardGMInfo.template_type", "templateType", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var template_type$field:int;

		public function clearTemplateType():void {
			hasField$0 &= 0xfffffffb;
			template_type$field = new int();
		}

		public function get hasTemplateType():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set templateType(value:int):void {
			hasField$0 |= 0x4;
			template_type$field = value;
		}

		public function get templateType():int {
			return template_type$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasTemplateId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, template_id$field);
			}
			if (hasNum) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, num$field);
			}
			if (hasTemplateType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, template_type$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var template_id$count:uint = 0;
			var num$count:uint = 0;
			var template_type$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (template_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: RewardGMInfo.templateId cannot be set twice.');
					}
					++template_id$count;
					this.templateId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (num$count != 0) {
						throw new flash.errors.IOError('Bad data format: RewardGMInfo.num cannot be set twice.');
					}
					++num$count;
					this.num = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (template_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: RewardGMInfo.templateType cannot be set twice.');
					}
					++template_type$count;
					this.templateType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
