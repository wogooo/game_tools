package com.msg.divine_pulse_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.common.ItemConsume;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CDivinePulseReq extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const DIVINE_PULSE_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.divine_pulse_pro.CDivinePulseReq.divine_pulse_id", "divinePulseId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var divinePulseId:int;

		/**
		 *  @private
		 */
		public static const PROP_INFO:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.divine_pulse_pro.CDivinePulseReq.prop_info", "propInfo", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.common.ItemConsume; });

		[ArrayElementType("com.msg.common.ItemConsume")]
		public var propInfo:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.divinePulseId);
			for (var propInfo$index:uint = 0; propInfo$index < this.propInfo.length; ++propInfo$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.propInfo[propInfo$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var divine_pulse_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (divine_pulse_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CDivinePulseReq.divinePulseId cannot be set twice.');
					}
					++divine_pulse_id$count;
					this.divinePulseId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					this.propInfo.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.common.ItemConsume()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
