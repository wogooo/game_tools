package com.msg.task {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.task.RunTaskInf;
	import com.msg.task.TaskTagInf;
	import com.msg.task.LoopTaskInf;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CurrentTaskInf extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TASK_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.CurrentTaskInf.task_id", "taskId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var taskId:int;

		/**
		 *  @private
		 */
		public static const TAG_LIST:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.task.CurrentTaskInf.tag_list", "tagList", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.task.TaskTagInf; });

		[ArrayElementType("com.msg.task.TaskTagInf")]
		public var tagList:Array = [];

		/**
		 *  @private
		 */
		public static const LOOP_INF:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.task.CurrentTaskInf.loop_inf", "loopInf", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.task.LoopTaskInf; });

		private var loop_inf$field:com.msg.task.LoopTaskInf;

		public function clearLoopInf():void {
			loop_inf$field = null;
		}

		public function get hasLoopInf():Boolean {
			return loop_inf$field != null;
		}

		public function set loopInf(value:com.msg.task.LoopTaskInf):void {
			loop_inf$field = value;
		}

		public function get loopInf():com.msg.task.LoopTaskInf {
			return loop_inf$field;
		}

		/**
		 *  @private
		 */
		public static const RUN_INF:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.task.CurrentTaskInf.run_inf", "runInf", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.task.RunTaskInf; });

		private var run_inf$field:com.msg.task.RunTaskInf;

		public function clearRunInf():void {
			run_inf$field = null;
		}

		public function get hasRunInf():Boolean {
			return run_inf$field != null;
		}

		public function set runInf(value:com.msg.task.RunTaskInf):void {
			run_inf$field = value;
		}

		public function get runInf():com.msg.task.RunTaskInf {
			return run_inf$field;
		}

		/**
		 *  @private
		 */
		public static const PROPS_TASK:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.task.CurrentTaskInf.props_task", "propsTask", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var props_task$field:Boolean;

		private var hasField$0:uint = 0;

		public function clearPropsTask():void {
			hasField$0 &= 0xfffffffe;
			props_task$field = new Boolean();
		}

		public function get hasPropsTask():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set propsTask(value:Boolean):void {
			hasField$0 |= 0x1;
			props_task$field = value;
		}

		public function get propsTask():Boolean {
			return props_task$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.taskId);
			for (var tagList$index:uint = 0; tagList$index < this.tagList.length; ++tagList$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.tagList[tagList$index]);
			}
			if (hasLoopInf) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, loop_inf$field);
			}
			if (hasRunInf) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, run_inf$field);
			}
			if (hasPropsTask) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, props_task$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var task_id$count:uint = 0;
			var loop_inf$count:uint = 0;
			var run_inf$count:uint = 0;
			var props_task$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (task_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CurrentTaskInf.taskId cannot be set twice.');
					}
					++task_id$count;
					this.taskId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					this.tagList.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.task.TaskTagInf()));
					break;
				case 3:
					if (loop_inf$count != 0) {
						throw new flash.errors.IOError('Bad data format: CurrentTaskInf.loopInf cannot be set twice.');
					}
					++loop_inf$count;
					this.loopInf = new com.msg.task.LoopTaskInf();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.loopInf);
					break;
				case 4:
					if (run_inf$count != 0) {
						throw new flash.errors.IOError('Bad data format: CurrentTaskInf.runInf cannot be set twice.');
					}
					++run_inf$count;
					this.runInf = new com.msg.task.RunTaskInf();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.runInf);
					break;
				case 5:
					if (props_task$count != 0) {
						throw new flash.errors.IOError('Bad data format: CurrentTaskInf.propsTask cannot be set twice.');
					}
					++props_task$count;
					this.propsTask = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
