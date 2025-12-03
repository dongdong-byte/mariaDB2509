package kim.projectdockerdb.controller;


import kim.projectdockerdb.mapper.UniversalMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Controller
@RequiredArgsConstructor
public class AdminController {
    private final UniversalMapper universalMapper;

    @GetMapping("/")
    public String index(){
        return "index";
    }

    @GetMapping("/view")
    public String viewTable(@RequestParam String tableName , Model model){
        // 1. DB에서 조회
        List<Map<String, Object>> dataList = universalMapper.findAll(tableName);

        // [디버깅용 로그] 콘솔에 이 줄이 찍히는지 확인하세요!
        System.out.println(">>> [DEBUG] 조회된 테이블: " + tableName);
        System.out.println(">>> [DEBUG] 데이터 개수: " + (dataList != null ? dataList.size() : "NULL"));

        // 2. 컬럼명 추출
        List<String> columns = new ArrayList<>();
        if (dataList != null && !dataList.isEmpty()) {
            columns.addAll(dataList.get(0).keySet());
        }

        // 3. 모델에 담기 (이 이름 "dataList"가 HTML이랑 같아야 함)
        model.addAttribute("tableName", tableName);
        model.addAttribute("columns", columns);
        model.addAttribute("dataList", dataList);

        return "view";

    }
}
