"""
Copyright 2022 Efinix.Inc. All Rights Reserved.
You may obtain a copy of the license at
https://www.efinixinc.com/software-license.html
"""

from genericpath import exists
import sys,math,re,os,subprocess,platform,shutil
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *
from functools import partial
from lib.auto_resizing_text_edit import AutoResizingTextEdit
import warnings
from lib.resource_lib import ResourceUtil



logo_path = os.path.join(os.path.dirname(os.path.dirname(os.getcwd())),"docs/efinix-logo")

params = {
    "CPU CONFIG": {
        'type': 'l',
        'val': "SINGLE CORE",
        'combo':["SINGLE CORE","MULTICORE"],
        'exclude_setting':True,
        'visible': True,
        'children' : {
                "CPU ID": {
                'type': 'l',
                'val': "0",
                'combo':["0","1","2","3"],
                'require': "MULTICORE",
                'visible': True,
                'exclude_setting':True,
            }
        }
    },
    "SYSTEM" : {
        'type': 'dd',
        'visible' : True,
        'val': True,
        'children' : {      
                "AXI_DW": {
                'type': 'l',
                'val': "128",
                'combo':["32","64","128","256","512"],
                'visible': True,
            }
        }
    },
    "CONV_DEPTHW_MODE": {
        'type': 'l',
        'combo':["STANDARD", "LITE", "DISABLE"],
        'val': "STANDARD",
        'visible': True,
        'res': True,        
        'children': {
            "CONV_DEPTHW_STD_IN_PARALLEL": {
                'type': 'n',
                'val': 8,
                'min' : 1,
                'max' : 128,
                'visible': True,
                'require': "STANDARD",
                'regen': True
            },
            "CONV_DEPTHW_STD_OUT_PARALLEL": {
                'type': 'n',
                'val': 4,
                'min' : 1,
                'max' : 128,
                'visible': True,
                'require': "STANDARD",
                'regen': True
            },
            "CONV_DEPTHW_STD_OUT_CH_FIFO_A": {
                'type': 'n',
                'val': 512,
                'visible': False,
                'regen' : True,
                'require': "STANDARD"
            },
            "CONV_DEPTHW_STD_FILTER_FIFO_A": {
                'type': 'n',
                'val': 512,
                'visible': False,
                'regen' : True,
                'require': "STANDARD"
            },
            "CONV_DEPTHW_STD_CNT_DTH": {
                'type': 'n',
                'val': 256,
                'visible': False,
                'regen' : True,
                'require': "STANDARD"
            },
            "CONV_DEPTHW_LITE_PARALLEL": {
                'type': 'n',
                'val': 4,
                'min' : 1,
                'max' : 8,
                'visible': True,
                'require': "LITE"
            },
            "CONV_DEPTHW_LITE_AW": {
                'type': 'n',
                'val': 7,
                'visible': False,
                'require': "LITE"
            }                    
        }
    },    
    "ADD_MODE": {
        'type': 'l',
        'combo':["STANDARD", "LITE", "DISABLE"],
        'res': True,
        'val': "STANDARD",
        'visible': True
    },
    "LR_MODE": {
        'type': 'l',
        'combo':["STANDARD", "DISABLE"],
        'res': True,
        'val': "STANDARD",
        'visible': True
    },

    "FC_MODE": {
        'type': 'l',
        'combo':["STANDARD","LITE", "DISABLE"],
        'val': "STANDARD",
        'visible': True,
        'res': True,
        'children': {
            "FC_MAX_IN_NODE": {
                'type': 'n',
                'val': 640,
                'visible': False,
                'require': "LITE"
            },
            "FC_MAX_OUT_NODE": {
                'type': 'n',
                'val': 640,
                'visible': False,
                'require': "LITE"
            }
        }
    },
    "MUL_MODE": {
        'type': 'l',
        'combo':["STANDARD","LITE", "DISABLE"],
        'val': "STANDARD",
        'res': True,        
        'visible': True
    },
    "MIN_MAX_MODE": {
        'type': 'l',
        'combo':["STANDARD","LITE", "DISABLE"],
        'val': "STANDARD",
        'res': True,
        'visible': True
    },
    "TINYML_CACHE" : {
        'type': 'l',
        'visible' : True,
        'combo' : ["ENABLE","DISABLE"],
        'val': "DISABLE",
        'res': True,
        'children' : {   
                "CACHE_DEPTH": {
                    'type': 'l',
                    'val': "512",
                    'combo':["512", "1024", "2048", "4096", "8192", "16384"],
                    'visible': True,
                    'require': "ENABLE"
                }
            }
        }
}

p2 = {}

mode_selection = {
    "DISABLE" : 0,
    "LITE" : 1,
    "STANDARD" : 2,
    "ENABLE" : 1
}

class Widget(QWidget):
    def __init__(self):
        super().__init__()
        R = QVBoxLayout()
        V = QVBoxLayout()
        H = QHBoxLayout()
        E = QTextEdit()
        Z = QTextEdit()
        note_editor = AutoResizingTextEdit()
        note_editor.setMinimumLines(2)
        note_editor.setReadOnly(True)
        note_editor_path = os.path.join(os.getcwd(),'lib/INFO.txt')
        self.activate_in_parallel_modify = False
        self.tflite_gen = False
        self.notes_description(note_editor,note_editor_path)
        app.setStyle("Fusion")
        self.E = E
        scroll = QScrollArea()
        container = QWidget()
        container.setLayout(V)
        scroll.setWidget(container)
        scroll.setWidgetResizable(True)
        self.res_util_lib=ResourceUtil()
        self.curr_cache_text="ENABLE"
        self.update_cache_text=False
        self.parse_cache_depth = 0
        
        #H.addLayout(V)
        H.addWidget(scroll)

        Rvbox = QVBoxLayout()
        label = QLabel('Resource Estimator')
        font = QFont()
        font.setBold(True)
        label.setFont(font)
        Rvbox.addWidget(label)
        self.datasheet = QTableView()
        # self.datasheet.setSizeAdjustPolicy(QAbstractScrollArea.AdjustToContents)
        sm = QStandardItemModel()
        sm.setHorizontalHeaderLabels(["Layer/Module","LUTs", "FFs", "ADDs", "RAM Blocks", "DSP Blocks"])
        self.datasheet.setModel(sm)
        self.datasheet.setColumnWidth(0,180)
        self.res_model = sm
        self.datasheet.setEditTriggers(QAbstractItemView.NoEditTriggers)
        self.model_loaded = False
        Rvbox.addWidget(self.datasheet)
        Rvbox.addWidget(E)
        H.addLayout(Rvbox)

        #H.addWidget(E)
        gen = QPushButton("Generate")
        open = QPushButton("Open")
        flabel = QLabel("Model File: ")
        self.file = QLineEdit("")

        size_policy = QSizePolicy(0, 1)
        Bottom = QHBoxLayout()
        open.setSizePolicy(size_policy)
        gen.setSizePolicy(size_policy)
        Bottom.addWidget(flabel)
        Bottom.addWidget(self.file)
        Bottom.addWidget(open)
        Bottom.addWidget(gen)
        R.addLayout(H)
        R.addLayout(Bottom)
        self.setLayout(R)
        self.tree = QTreeWidget()
        V.addWidget(self.tree)
        V.addWidget(note_editor)
        self.tree.setHeaderLabels(["Parameter", "Value"])
        self.map_params(params, self.tree)
        self.tree.expandAll()
        self.tree.resizeColumnToContents(0)
        self.resize(1024, 768)
        self.model_file = None
        self.current_dir = os.getcwd()
        self.op_path = None
        self.running = False

        def openfile():
            path = QFileDialog.getOpenFileName(filter = "*.tflite")
            if(path[0]):
                self.file.setText(path[0])
                self.model_file = path[0]
                self.parse_model()
                self.tflite_gen = True                
            
        open.clicked.connect(openfile)
        gen.clicked.connect(self.generate)

        self.resize(1420, 800)


    def map_params(self, params, root):
        mw = 0
        mh = 0
        fm = QFontMetrics(QFont())
        for p in params:
            rect = fm.boundingRect(p)
            if rect.width() > mw:
                mw = rect.width()
            if rect.height() > mh:
                mh = rect.height()
        for p in params:
            val = params[p]
            p2[p] = val
            if not val['visible']:
                continue
            c = QTreeWidgetItem(root)
            c.setText(0, p)
            if 'children' in val:
                self.map_params(val['children'], c)
            if val['type'] == 'dd':
                 continue
            if val['type'] == 'b':
                check = QCheckBox()
                self.tree.setItemWidget(c, 1, check)
                check.setChecked(val['val'])
                def slot(item, val, state):
                    hide = state == Qt.Checked
                    val["val"] = hide
                    if item.childCount() <= 0:
                        return
                    item.child(0).setHidden(not hide)
                check.stateChanged.connect(partial(slot, c, val))
                val['qval'] = check
            elif val['type'] == 'l':
                box = QComboBox()
                box.addItems(val['combo'])
                self.tree.setItemWidget(c, 1, box)
                box.setCurrentIndex(box.findText(val['val']))
                val['qval'] = box
                def slot(val, p, text):
                    val['val'] = text
                    if(p == "AXI_DW"):
                        self.modify_in_out_parallel_param(p2)
                        self.modify_cache_param()
                    if(p == "TINYML_CACHE"):
                        self.modify_cache_param()
                    if(p == "CPU CONFIG"):
                        self.check_cpu_param(p2)
                    self.check_cache_enable(p2)
                    self.res_utilization()
                    if not 'children' in val:
                        return
                    children = val['children']
                    for i in children:
                        if 'qval' in children[i]:
                            show = children[i]['require'] == text
                            children[i]['qval'].setEnabled(show) 
                box.currentTextChanged.connect(partial(slot, val, p))
                slot(val,p, val['val'])
            elif val['type'] == 'n':
                line = QSpinBox()
                if('min' in val):
                    line.setMinimum(int(val['min']))
                if('max' in val):
                    line.setMaximum(int(val['max']))
                else:
                    line.setMaximum(99999)
                line.setValue(int(val['val']))
                line.setObjectName(p)
                self.tree.setItemWidget(c, 1, line)
                val['qval'] = line
                def slot(mval, text):
                   if 'regen' in mval:
                       self.tflite_gen = False
                   if text == "":
                       return
                   mval['val'] = int(text)
                   self.res_utilization()
                line.textChanged.connect(partial(slot, val))
        #Only start calculating the in out parallel based on AXI DW once all param is mapped
        if(p2.get("CONV_DEPTHW_STD_IN_PARALLEL")):
            self.modify_in_out_parallel_param(p2,activate = 1)
            

                


    def res_utilization(self):
        if not self.model_loaded:
            return
        self.res_model.clear()
        # self.datasheet.clearSpans()
        res = [0, 0, 0, 0, 0]
        total_res = res.copy()
        layer_mode = []
        self.res_util_lib.initialize_param(p2)
        self.res_model.setHorizontalHeaderLabels(["Layer/Module","LUTs", "FFs", "ADDs", "RAM Blocks", "DSP Blocks"])
        for i in p2:
            val = p2[i]
            if 'res' not in val:
                continue
            value = val['val']
            if value == "DISABLE":
                continue
            layer_mode.append(value)
            r=self.res_util_lib.evaluate_res(i,value)
            for e in range(5):
                total_res[e] = total_res[e] + r[e]
            self.append_row(i.replace("_MODE",""),r)
        self.datasheet.setColumnWidth(0,180)
        
        common_res=self.res_util_lib.evaluate_common_module(layer_mode)
        if(common_res):
            for e in range(5):
                total_res[e] = total_res[e] + common_res[e]
            self.append_row("COMMON",common_res)
        self.append_row("TINYML_ACCELERATOR",total_res,bold_font=True)

    def check_cpu_param(self,params_list):
        cpu_config = params_list.get("CPU CONFIG")["val"]
        if "SINGLE CORE" in cpu_config:
            cpuid_val=params_list.get("CPU ID")['qval']
            cpuid_val.setCurrentIndex(cpuid_val.findText("0"))
            

 
    def check_cache_enable(self,params_list):
        count_standard=0
        for p in params_list:
            if("_MODE" in p):
                if ("STANDARD" in params_list[p]['val']):
                    count_standard+=1
        if('TINYML_CACHE' in params_list):
            if(params_list['TINYML_CACHE'].get('qval')):
                cache_box=params_list['TINYML_CACHE']['qval']
                if(count_standard<1):
                    if(not self.update_cache_text):
                        self.update_cache_text=True
                    cache_box.setCurrentIndex(cache_box.findText('DISABLE'))
                    params_list['TINYML_CACHE']['val'] = 'DISABLE'
                    cache_box.setEnabled(False)
                else:
                    if(self.update_cache_text):
                        cache_box.setCurrentIndex(cache_box.findText(self.curr_cache_text))
                        self.update_cache_text=False
                        params_list['TINYML_CACHE']['val'] = self.curr_cache_text
                    cache_box.setEnabled(True)

    def calc_cache_depth(self,val):
        cache_size_val = 2 ** round(math.log2(int(val))) 
        if (cache_size_val > int(p2.get("CACHE_DEPTH")['combo'][-1])):
            return p2.get("CACHE_DEPTH")['combo'][-1]
        elif (cache_size_val < int(p2.get("CACHE_DEPTH")['combo'][0])):
            return p2.get("CACHE_DEPTH")['combo'][0]
        else: 
            return cache_size_val      

    def append_row(self,module,data,bold_font=False):
        data_row=[]
        font = QFont()
        background=QColor(255,255,255)
        if(bold_font):
            font.setBold(True)
            background=QColor(200,200,200)

        module=QStandardItem(module)
        module.setFont(font)
        module.setBackground(background)

        for i in data:
            col=QStandardItem(str(i))
            col.setFont(font)
            col.setBackground(background)
            data_row.append(col)

        self.res_model.appendRow([module,
            data_row[0], 
            data_row[1], 
            data_row[2], 
            data_row[3], 
            data_row[4]])



            
    def dump_params(self, mparams):
        vout = ""
        def iter(p):
            cpuid = int(p2.get("CPU ID")["val"])
            vout = ""
            cout = ""
            dout = ""
            for i in p:
                val = p[i]
                if val['type'] == 'n' and 'exclude_setting' not in val:
                    vout += '`define TML_C%d_%s\t%d\n' % (cpuid,i, val['val'])
                if val['type'] == 'l' and 'exclude_setting' not in val:
                    if(val['val'].isnumeric()):
                        vout += '`define TML_C%d_%s\t%d\n' % (cpuid,i, int(val['val']))
                    else:
                        vout += '`define TML_C%d_%s\t"%s"\n' % (cpuid,i, val['val'])
                if 'children' in val:
                    v= iter(val['children'])
                    vout += v
            return vout

        vout = iter(mparams)

        #For profiling
        cpuid = int(p2.get("CPU ID")["val"])
        vh = os.path.join(self.op_path,f"tinyml_core{cpuid}_define.v")
        vhp = os.path.relpath(vh).replace("\\",'/')
        vh = open(vh, "w")
        vh.write(vout)
        vh.close()
        #self.E.append(vout)
        self.E.setFontWeight(QFont.Bold)
        self.E.append("Hardware Definition File")   
        self.E.setFontWeight(QFont.Normal)     
        self.E.append("Generated hardware definition file : %s..." % vhp)
        self.E.append("Include the file under : source/tinyml")
        self.E.setFontWeight(QFont.Bold)
        self.E.append("End File Generation")  
        self.E.append("\n")      
        self.E.append("\n")      
        self.E.setFontWeight(QFont.Normal)             

    def dump_model(self):
        fd = open(self.model_file, 'rb')
        data = fd.read()
        base = os.path.basename(self.model_file).replace('.tflite', "")
        oh = os.path.join(self.op_path, base + "_model_data.h")
        oc = os.path.join(self.op_path, base + "_model_data.cc")
        ohp = os.path.relpath(oh).replace("\\","/")
        ocp = os.path.relpath(oc).replace("\\","/")
        self.E.setFontWeight(QFont.Bold)             
        self.E.append("Software Model File") 
        self.E.setFontWeight(QFont.Normal)                    
        self.E.append("Generated model file: %s..." % ocp)

        dlen = "const unsigned int "+base+"_model_data_len = %d;\n" % len(data)
        array = "const unsigned char "+base+"_model_data[] = {"
        oc = open(oc, "w")
        oc.write('#include "%s"\n' % (base + "_model_data.h"))
        oc.write(dlen)
        for i in range(len(data)):
            d = data[i]
            if (i % 16) == 0:
                oc.write(array)
                array = '\n\t'
            if i < len(data) - 1:
                array += ('0x%.2x' % d) + ", "
            else:
                array += ('0x%.2x' % d)
        array += "};"
        oc.write(array)
        oc.close()
        self.E.append("Generated model file: %s... " % ohp)
        self.E.append("Include the file under :" + "embedded_sw/SapphireSoC/software/standalone/<application_name>/src/model")
        self.E.setFontWeight(QFont.Bold)             
        self.E.append("End File Generation") 
        self.E.append("\n")       
        self.E.setFontWeight(QFont.Normal)             
        oh = open(oh, "w")
        oh.write("#ifndef _%s_MODEL_DATA_H\n#define _%s_MODEL_DATA_H\n" %(base.upper(), base.upper()))
        oh.write('extern const unsigned int %s_model_data_len;\n' % base)
        oh.write('extern const unsigned char %s_model_data[];\n' % base)
        oh.write("#endif")
        oh.close()

    def parse_model(self,check_regen = False):
        ic = self.findChild(QObject, 'CONV_DEPTHW_STD_IN_PARALLEL')
        oc = self.findChild(QObject, 'CONV_DEPTHW_STD_OUT_PARALLEL')
        axi_dw = p2.get("AXI_DW")['val']
        dir = os.path.join(os.path.dirname(__file__), "bin")
        if dir == "":
            dir = "./bin"
        path = dir + "/tflite"
        if platform.system() == "Windows":
            path += ".exe"
        with subprocess.Popen([path, self.model_file, ic.text(), oc.text(), axi_dw], 
            stderr=subprocess.PIPE,
            bufsize=1, universal_newlines=True) as p:
            begin = False
            for line in p.stderr:
                self.model_loaded = True
                l = str(line)
                l = l.replace("\n", "").replace("\r", "")
                if l.startswith("===="):
                    begin = not begin
                elif begin and len(l) > 1:
                    v = l.split(':')
                    #iter(params, v[0].upper(), v[1])
                    if v[0].upper() in p2:
                        val = p2.get(v[0].upper())
                        if (not check_regen) or (check_regen and 'regen' in val):
                            if val['type'] == 'b':
                                val['val'] = int(v[1]) > 0
                                if 'qval' in val:
                                    val['qval'].setChecked(int(v[1]) > 0)
                            elif val['type'] == 'l':
                                if 'qval' in val:
                                    box = val['qval']
                                    if int(v[1]) == 0:
                                        box.setCurrentIndex(box.findText('DISABLE'))
                                        val['val'] = 'DISABLE'
                                        box.setEnabled(False)
                                    elif val['val'].isdigit():
                                        if(v[0].upper() == 'CACHE_DEPTH'):
                                            val['val'] = str(self.calc_cache_depth(v[1]))
                                            self.parse_cache_depth = str(self.calc_cache_depth(v[1]))
                                        else:
                                            val['val'] =  v[1]
                                        box.setCurrentIndex(box.findText(val['val']))
                                        box.setEnabled(True)
                                    else:
                                        val['val'] = box.itemText(0)
                                        box.setCurrentIndex(0)
                                        box.setEnabled(True)
                                    if 'children' in val:
                                        children = val['children']
                                        for i in children:
                                            if 'qval' in children[i]:
                                                show = children[i]['require'] == val['val']
                                                children[i]['qval'].setEnabled(show)                         

                            elif val['type'] == 'n':
                                val['val'] = int(v[1])
                                if 'qval' in val:
                                    val['qval'].setValue(int(v[1]))
                            else:
                                continue
        self.res_utilization()
        print("done...")

    def get_cache_mode(self):
        if("ENABLE" in p2.get("TINYML_CACHE")['val'] and "STANDARD" in p2.get("CONV_DEPTHW_MODE")['val']):
            curr_cache_index = p2.get("CACHE_DEPTH")['combo'].index(p2.get("CACHE_DEPTH")['val'])
            rec_cache_index = p2.get("CACHE_DEPTH")['combo'].index(self.parse_cache_depth)
            if(rec_cache_index - curr_cache_index >= 2):
                return 0
            else :
                return 1
        else:
            return 0

    def modify_cache_param(self):
        if(self.tflite_gen and "ENABLE" in p2.get("TINYML_CACHE")['val'] and "STANDARD" in p2.get("CONV_DEPTHW_MODE")['val']):
            ic = self.findChild(QObject, 'CONV_DEPTHW_STD_IN_PARALLEL')
            oc = self.findChild(QObject, 'CONV_DEPTHW_STD_OUT_PARALLEL')
            axi_dw = p2.get("AXI_DW")['val']
            dir = os.path.join(os.path.dirname(__file__), "bin")
            if dir == "":
                dir = "./bin"
            path = dir + "/tflite"
            if platform.system() == "Windows":
                path += ".exe"
            with subprocess.Popen([path, self.model_file, ic.text(), oc.text(), axi_dw], 
                stderr=subprocess.PIPE,
                bufsize=1, universal_newlines=True) as p:
                begin = False
                for line in p.stderr:
                    self.model_loaded = True
                    l = str(line)
                    l = l.replace("\n", "").replace("\r", "")
                    if l.startswith("===="):
                        begin = not begin
                    elif begin and len(l) > 1:
                        v = l.split(':')
                        #iter(params, v[0].upper(), v[1])
                        if v[0].upper() in p2:
                            val = p2.get(v[0].upper())
                            if val['type'] == 'l':
                                if 'qval' in val:
                                    box = val['qval']
                                    if val['val'].isdigit():
                                        if(v[0].upper() == 'CACHE_DEPTH'):
                                            val['val'] = str(self.calc_cache_depth(v[1]))
                                            self.parse_cache_depth = str(self.calc_cache_depth(v[1]))
                                            box.setCurrentIndex(box.findText(val['val']))
                                            box.setEnabled(True)
            self.res_utilization()
            print("done...")
            
 
            
    def generate(self):
        if self.running:
            print("return...")
            return
        if (not self.model_file) or (not exists(self.model_file)):
            QMessageBox.about(self, "Error", "Not a valid tflite file!")
            return
        self.running = True
        self.E.clear()
        self.check_regen_stat()
        
        if not self.tflite_gen:
            self.parse_model(check_regen = True)
            self.tflite_gen = True

        self.op_path = self.create_op_folder(self.current_dir,delete_file=True)
        self.dump_params(params)
        self.dump_model()
        self.running = False
        

    def notes_description(self,editor,note_file):
        editor.setFontWeight(QFont.Bold)
        editor.append("NOTES:")
        editor.setFontWeight(QFont.Normal)
        with open(note_file) as f:
            for note in f:
                editor.append(note.strip())
    
    def create_op_folder(self,path,delete_file=True):
        base = os.path.basename(self.model_file).replace('.tflite', "")
        cpuid = int(p2.get("CPU ID")["val"])
        base = f"{base}_core{cpuid}"
        output_file = os.path.join(path,'output')
        output_file = os.path.join(output_file,base)
        if os.path.exists(output_file):
            if(delete_file):
                shutil.rmtree(output_file,ignore_errors=True)
                os.makedirs(output_file,exist_ok=True)
        else:
            os.makedirs(output_file,exist_ok=True)
        return output_file

    def modify_in_out_parallel_param(self,params_list,depth_multiplier_val=1,activate=0):
        ##Modify custom steps to support power of 2
        # Define the step size (powers of 2 behavior)
        def custom_step_by(self, steps: int):
            current_value = self.value()
            
            # Increment or decrement based on steps
            if steps > 0:
                new_value = current_value * 2  # Multiply by 2 for positive steps (powers of 2)
            else:
                new_value = current_value // 2  # Divide by 2 for negative steps
            
            # Set the new value
            self.setValue(new_value)

        if(self.activate_in_parallel_modify):
            curr_axi_dw = int(params_list.get("AXI_DW")["val"])

            #For IN_PARALLEL
            #Limit to 16 for current config
            curr_conv_depthw_par_in = params_list.get("CONV_DEPTHW_STD_IN_PARALLEL")
            conv_depthw_std_parallel_in_max = int(curr_axi_dw/8)  if int(curr_axi_dw/8) < 16 else 16
            conv_depthw_std_parallel_in_min = depth_multiplier_val
            if(curr_conv_depthw_par_in['val']>conv_depthw_std_parallel_in_max):
                curr_conv_depthw_par_in['val'] = int(conv_depthw_std_parallel_in_max)
            curr_conv_depthw_par_in['qval'].setMinimum(int(conv_depthw_std_parallel_in_min))
            curr_conv_depthw_par_in['qval'].setMaximum(int(conv_depthw_std_parallel_in_max))
            curr_conv_depthw_par_in['qval'].setValue(int(curr_conv_depthw_par_in['val']))
            # Override the stepBy method. Power of 2 
            curr_conv_depthw_par_in['qval'].stepBy = custom_step_by.__get__(curr_conv_depthw_par_in['qval'])

            #For OUT_PARALLEL
            #Limit to 16 for current config
            curr_conv_depthw_par_out = params_list.get("CONV_DEPTHW_STD_OUT_PARALLEL")
            conv_depthw_std_parallel_out_max = int(curr_axi_dw/32)  if int(curr_axi_dw/32) < 16 else 16

            if(curr_conv_depthw_par_out):
                if(curr_conv_depthw_par_out['val']>conv_depthw_std_parallel_out_max):
                    curr_conv_depthw_par_out['val'] = int(conv_depthw_std_parallel_out_max)

                curr_conv_depthw_par_out['qval'].setMinimum(int(1))
                curr_conv_depthw_par_out['qval'].setMaximum(conv_depthw_std_parallel_out_max)
                curr_conv_depthw_par_out['qval'].setValue(int(curr_conv_depthw_par_out['val']))
                curr_conv_depthw_par_out['qval'].stepBy = custom_step_by.__get__(curr_conv_depthw_par_out['qval'])
        if(activate==1):
            self.activate_in_parallel_modify=True

    
    #Require to check if the desired parameter with regen is enabled or disabled  
    def check_regen_stat(self):
        regen_list=["CONV_DEPTHW_STD_IN_PARALLEL","CONV_DEPTHW_STD_OUT_PARALLEL"]
        for item in regen_list:
            item_dict=p2.get(item)
            if(not item_dict['qval'].isEnabled()):
                self.tflite_gen=True

        


if __name__ == '__main__':
    warnings.filterwarnings("ignore", category=DeprecationWarning) 
    app = QApplication(sys.argv)
    window = Widget()
    window.show()
    window.setWindowTitle("Efinix TinyML Generator")
    window.setWindowIcon(QIcon(logo_path))
    app.exec()
