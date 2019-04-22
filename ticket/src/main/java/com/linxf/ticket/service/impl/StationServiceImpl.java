package com.linxf.ticket.service.impl;

import com.linxf.ticket.dataobject.Station;
import com.linxf.ticket.repository.StationRepository;
import com.linxf.ticket.service.StationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import java.util.List;

/**
 * @author lintao
 * @date 2019/4/16
 */
@Service
public class StationServiceImpl implements StationService {

    @Autowired
    private StationRepository stationRepository;

    /**
     * 新增车站
     *
     * @param station
     */
    @Override
    public void addStation(Station station) {
        stationRepository.save(station);
    }

    /**
     * 添加车站列表
     *
     * @param stationList
     */
    @Override
    @Transactional
    public void addStationList(List<Station> stationList) {
        Assert.notNull(stationList, "车站列表不能为空！");
        Assert.notNull(stationList.get(0), "车站列表不能为空！");
        for (Station station : stationList) {
            this.addStation(station);
        }
    }

    /**
     * 查询某辆列车的车站列表
     *
     * @param tid
     * @return
     */
    @Override
    public List<Station> findListByTid(String tid) {
        return stationRepository.findAllByTid(tid);
    }

    /**
     * 修改单条车站信息
     *
     * @param station
     */
    @Override
    public void updateStationInfo(Station station) {
        stationRepository.save(station);
    }
}
